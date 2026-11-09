import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/app/app.dart';
import 'package:cibermax_movil/app/store/shop_scope.dart';
import 'package:cibermax_movil/features/home/presentation/pages/home_page.dart';
import 'package:cibermax_movil/features/profile/presentation/widgets/customer_drawer.dart';
import 'package:cibermax_movil/features/orders/domain/entities/customer_order.dart';
import 'package:cibermax_movil/app/router/instant_page_route.dart';
import 'package:cibermax_movil/app/theme/app_theme.dart';
import 'package:cibermax_movil/features/addresses/presentation/pages/addresses_page.dart';
import 'package:cibermax_movil/features/addresses/presentation/pages/address_form_page.dart';
import 'package:cibermax_movil/features/orders/presentation/pages/orders_page.dart';
import 'package:cibermax_movil/features/orders/presentation/pages/order_detail_page.dart';
import 'package:cibermax_movil/features/notifications/presentation/pages/notifications_page.dart';
import 'package:cibermax_movil/features/reviews/presentation/pages/my_reviews_page.dart';
import 'package:cibermax_movil/features/reviews/presentation/pages/review_form_page.dart';
import 'package:cibermax_movil/features/cart/presentation/pages/cart_page.dart';

Future<void> openAccount(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(NavigationDestination, 'Perfil'));
  await tester.pumpAndSettle();
  if (find.text('Continuar con Google').evaluate().isNotEmpty) {
    await tester.tap(find.text('Continuar con Google'));
    await tester.pumpAndSettle();
  }
  await tester.scrollUntilVisible(
    find.text(label),
    100,
    scrollable: find.descendant(
      of: find.byType(CustomerDrawer),
      matching: find.byType(Scrollable),
    ),
  );
  await Scrollable.ensureVisible(
    tester.element(find.text(label)),
    alignment: .5,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> saveForm(WidgetTester tester, String key) async {
  await Scrollable.ensureVisible(
    tester.element(find.byKey(Key(key))),
    alignment: .5,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  for (final layout in [
    (size: const Size(375, 812), dark: false),
    (size: const Size(812, 375), dark: true),
  ]) {
    testWidgets(
      'account screens fit ${layout.size} with large text and dark=${layout.dark}',
      (tester) async {
        tester.view.physicalSize = layout.size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });
        await tester.pumpWidget(const CibermaxApp());
        await tester.pumpAndSettle();
        final root = tester.element(find.byType(HomePage));
        final shop = ShopScope.of(root);
        final address = await shop.saveAddress(
          department: 'Junín',
          province: 'Huancayo',
          district: 'El Tambo',
          street: 'Av. Dirección de prueba extensa, bloque A, interior 123',
        );
        await shop.saveAddress(
          department: 'Junín',
          province: 'Huancayo',
          district: 'Huancayo',
          street: 'Jr. Segunda dirección 456',
        );
        shop.add(shop.products.first, 2);
        final order = await shop.placeOrder();
        await shop.saveReview(
          productId: shop.products.first.id,
          rating: 5,
          comment: 'Una reseña de varias líneas para comprobar que el texto ampliado se muestre completo.',
        );
        shop.add(shop.products.first);
        for (final page in <Widget>[
          const AddressesPage(),
          const NotificationsPage(),
          const OrdersPage(),
          OrderDetailPage(orderId: order.id),
          const MyReviewsPage(),
          AddressFormPage(address: address),
          ReviewFormPage(product: shop.products.first),
          const CartPage(),
        ]) {
          Navigator.of(root).push<void>(
            InstantPageRoute<void>(
              builder: (_) => Theme(
                data: AppTheme.reference(dark: layout.dark),
                child: page,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final scroll = find
              .descendant(
                of: find.byType(ListView).last,
                matching: find.byType(Scrollable),
              )
              .first;
          await tester.drag(scroll, const Offset(0, -1400));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          Navigator.of(root).pop();
          await tester.pumpAndSettle();
        }
      },
    );
  }

  testWidgets('profile addresses can be validated, added, edited and deleted', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    await openAccount(tester, 'Mis direcciones');
    await tester.tap(find.text('Agregar dirección'));
    await tester.pumpAndSettle();
    await saveForm(tester, 'save-address');
    expect(find.text('Completa este campo.'), findsNWidgets(4));
    for (var index = 0; index < 4; index++) {
      await tester.enterText(
        find.byKey(ValueKey('address-field-$index')),
        const ['Junín', 'Huancayo', 'El Tambo', 'Jr. Principal 123'][index],
      );
    }
    await saveForm(tester, 'save-address');
    expect(find.text('Jr. Principal 123'), findsOneWidget);
    expect(shop.addresses.length, 1);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('address-field-2')))
          .controller!
          .text,
      'El Tambo',
    );
    await tester.enterText(
      find.byKey(const ValueKey('address-field-3')),
      'Jr. Actualizada 456',
    );
    await saveForm(tester, 'save-address');
    expect(find.text('Jr. Actualizada 456'), findsOneWidget);
    await tester.tap(find.byTooltip('Eliminar dirección Jr. Actualizada 456'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Guarda tu primera dirección'), findsOneWidget);
    expect(shop.addresses, isEmpty);
    expect(shop.selectedAddress, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'written reviews appear under the corresponding product and in My reviews',
    (tester) async {
      await tester.pumpWidget(const CibermaxApp());
      await tester.pumpAndSettle();
      final root = tester.element(find.byType(HomePage));
      final shop = ShopScope.of(root);
      final product = shop.products.first;
      Navigator.of(root).pushNamed('/product', arguments: product);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Escribir reseña'),
        200,
        maxScrolls: 100,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('detail-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Escribir reseña')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Escribir reseña'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('5 estrellas'));
      await tester.enterText(
        find.byKey(const Key('review-comment')),
        'Excelente calidad de impresión.',
      );
      await saveForm(tester, 'save-review');
      expect(shop.reviews.single.productId, product.id);
      expect(shop.reviews.single.rating, 5);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await openAccount(tester, 'Mis reseñas');
      expect(find.text(product.name), findsOneWidget);
      expect(find.text('Excelente calidad de impresión.'), findsOneWidget);
      await tester.tap(find.byTooltip('Editar reseña de ${product.name}'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('4 estrellas'));
      await tester.enterText(
        find.byKey(const Key('review-comment')),
        'Actualicé mi opinión del producto.',
      );
      await saveForm(tester, 'save-review');
      expect(shop.reviews.length, 1);
      expect(shop.reviews.single.rating, 4);
      expect(find.text('Actualicé mi opinión del producto.'), findsOneWidget);
      await tester.tap(find.byTooltip('Eliminar reseña de ${product.name}'));
      await tester.pumpAndSettle();
      expect(find.text('Todavía no escribiste reseñas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('order notices open order details and can be marked read', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    await shop.saveAddress(
      department: 'Junín',
      province: 'Huancayo',
      district: 'Huancayo',
      street: 'Jr. Avisos 100',
    );
    shop.add(shop.products.first);
    final order = await shop.placeOrder();
    await shop.updateOrderStatus(order.id, OrderStatus.ready);
    await shop.updateOrderStatus(order.id, OrderStatus.onTheWay);
    await tester.pumpAndSettle();
    await openAccount(tester, 'Notificaciones');
    expect(find.text('Pedido realizado'), findsOneWidget);
    expect(find.text('Listo para enviar'), findsOneWidget);
    await tester.tap(find.text('En camino'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle del pedido'), findsOneWidget);
    expect(find.text(order.id), findsOneWidget);
    expect(shop.unreadNotificationCount, 2);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Marcar todas como leídas'));
    await tester.pumpAndSettle();
    expect(shop.unreadNotificationCount, 0);
    expect(tester.takeException(), isNull);
  });
}
