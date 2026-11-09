import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/app/app.dart';
import 'package:cibermax_movil/app/store/shop_scope.dart';
import 'package:cibermax_movil/features/home/presentation/pages/home_page.dart';
import 'package:cibermax_movil/features/profile/presentation/widgets/customer_drawer.dart';
import 'package:cibermax_movil/features/orders/domain/entities/customer_order.dart';

void main() {
  testWidgets('capture reference screens for visual review', (tester) async {
    final previousShadows = debugDisableShadows;
    debugDisableShadows = false;
    try {
      const fontDirectory = String.fromEnvironment('FONT_DIR');
      await tester.runAsync(() async {
        final loader = FontLoader('Roboto');
        for (final font in ['roboto-regular.ttf', 'roboto-bold.ttf']) {
          loader.addFont(
            File('$fontDirectory/$font')
                .readAsBytes()
                .then((bytes) => ByteData.sublistView(bytes)),
          );
        }
        await loader.load();
        final material = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await material.load();
        final cupertino = FontLoader('packages/cupertino_icons/CupertinoIcons')
          ..addFont(
            rootBundle.load(
              'packages/cupertino_icons/assets/CupertinoIcons.ttf',
            ),
          );
        await cupertino.load();
      });
      const ratio = 738 / 393;
      tester.view.physicalSize = const Size(738, 1600);
      tester.view.devicePixelRatio = ratio;
      tester.view.padding = const FakeViewPadding(
        top: 24 * ratio,
        bottom: 49 * ratio,
      );
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetPadding();
      });
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundary, child: const CibermaxApp()),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        for (final asset in [
          'restaurant.png',
          'taxi.png',
          'events.png',
          'liquor.png',
          'market.png',
          'candy-promo.png',
          'braza-promo.png',
          'llama-avatar.png',
        ]) {
          await precacheImage(
            AssetImage('assets/images/reference/$asset'),
            tester.element(find.byType(HomePage)),
          );
        }
        for (final product in ShopScope.of(
          tester.element(find.byType(HomePage)),
        ).products) {
          for (final asset
              in product.imageAssets.isEmpty
                  ? ['assets/images/products/${product.art}.png']
                  : product.imageAssets) {
            await precacheImage(
              AssetImage(asset),
              tester.element(find.byType(HomePage)),
            );
          }
        }
      });
      await tester.pumpAndSettle();

      Future<void> capture(String name) async {
        await tester.pumpAndSettle();
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        // Refresh retained route layers so offscreen captures include the AppBar.
        void repaint(RenderObject object) {
          object.markNeedsPaint();
          object.visitChildren(repaint);
        }

        repaint(render);
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final image = await render.toImage(pixelRatio: ratio);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('design-review/reference-$name.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      Future<void> selectFilter(String prefix, String id) async {
        final filter = find.byKey(ValueKey('$prefix-$id'));
        if (filter.evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            filter,
            -250,
            maxScrolls: 100,
            scrollable: find
                .descendant(
                  of: find.byKey(const Key('catalog-scroll')),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
        }
        await Scrollable.ensureVisible(tester.element(filter), alignment: .5);
        await tester.pumpAndSettle();
        await tester.tap(filter);
        await tester.pumpAndSettle();
      }

      await capture('home');
      await tester.tap(find.widgetWithText(NavigationDestination, 'Productos'));
      await tester.pumpAndSettle();
      await capture('products');
      await selectFilter('catalog-category', 'impresoras');
      await capture('printers');
      await selectFilter('catalog-subcategory', 'impresoras-wifi');
      await capture('products-wifi');
      await selectFilter('catalog-subcategory', 'all');
      await tester.scrollUntilVisible(
        find.text('Impresora HP Smart Tank 315'),
        100,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('catalog-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Impresora HP Smart Tank 315')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Impresora HP Smart Tank 315'));
      await tester.pumpAndSettle();
      await capture('printer-detail');
      await tester.tap(find.byTooltip('Aumentar cantidad'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('detail-add')));
      await tester.pumpAndSettle();
      await capture('cart-added-message');
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      final detailScroll = find
          .descendant(
            of: find.byKey(const Key('detail-scroll')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Reseñas'),
        250,
        maxScrolls: 100,
        scrollable: detailScroll,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Reseñas')),
        alignment: 0,
      );
      await tester.pumpAndSettle();
      await capture('product-reviews');
      tester.state<ScrollableState>(detailScroll).position.jumpTo(0);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      await selectFilter('catalog-category', 'impresoras');
      await selectFilter('catalog-subcategory', 'multifuncionales');
      await capture('subcategory-products');
      final accountShop = ShopScope.of(tester.element(find.byType(HomePage)));
      await accountShop.saveAddress(
        department: 'Junín',
        province: 'Huancayo',
        district: 'El Tambo',
        street: 'Av. Mariscal Castilla 120',
      );
      await accountShop.saveAddress(
        department: 'Junín',
        province: 'Huancayo',
        district: 'Huancayo',
        street: 'Jr. Lima 245',
      );
      await tester.tap(find.text('Carrito'));
      await tester.pumpAndSettle();
      await capture('cart-tab');
      await tester.tap(find.byKey(const Key('place-order')));
      await tester.pumpAndSettle();
      await capture('orders-tab');
      await tester.tap(find.text('Ver detalle'));
      await tester.pumpAndSettle();
      await capture('order-detail');
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await accountShop.updateOrderStatus(
        accountShop.orders.first.id,
        OrderStatus.ready,
      );
      await accountShop.updateOrderStatus(
        accountShop.orders.first.id,
        OrderStatus.onTheWay,
      );
      await accountShop.saveReview(
        productId: accountShop.products.first.id,
        rating: 5,
        comment: 'Muy buena calidad de impresión y fácil de usar.',
      );
      await tester.tap(find.text('Inicio'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NavigationDestination, 'Perfil'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar con Google'));
      await tester.pumpAndSettle();
      await capture('menu-top');
      Future<void> captureAccount(String label, String name) async {
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
        await capture(name);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(NavigationDestination, 'Perfil'));
        await tester.pumpAndSettle();
      }

      await captureAccount('Mis direcciones', 'addresses');
      await captureAccount('Notificaciones', 'notifications');
      await captureAccount('Mis reseñas', 'my-reviews');
      final scroll = find.descendant(
        of: find.byType(CustomerDrawer),
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.text('Cerrar sesión'),
        200,
        scrollable: scroll,
      );
      await capture('menu-bottom');
      await tester.scrollUntilVisible(
        find.text('Mi perfil'),
        -250,
        scrollable: scroll,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Mi perfil')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mi perfil'));
      await tester.pumpAndSettle();
      await capture('profile');
      await tester.tap(find.byKey(const ValueKey('profile-field-Nombres')));
      await tester.pumpAndSettle();
      await capture('edit-names');
      await tester.tap(find.byTooltip('Volver al perfil'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('profile-field-Tipo de documento')),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await Scrollable.ensureVisible(
        tester.element(
          find.byKey(const ValueKey('profile-field-Tipo de documento')),
        ),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('profile-field-Tipo de documento')),
      );
      await tester.pumpAndSettle();
      await capture('edit-document');
      await tester.tap(find.byTooltip('Volver al perfil'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('profile-field-Fecha de nacimiento')),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await Scrollable.ensureVisible(
        tester.element(
          find.byKey(const ValueKey('profile-field-Fecha de nacimiento')),
        ),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('profile-field-Fecha de nacimiento')),
      );
      await tester.pumpAndSettle();
      await capture('edit-birth-date');
      await tester.tap(find.byTooltip('Volver al perfil'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Cerrar sesión'),
        120,
        scrollable: find.byType(Scrollable).last,
      );
      await capture('profile-bottom');
      expect(tester.takeException(), isNull);
    } finally {
      debugDisableShadows = previousShadows;
    }
  }, skip: !const bool.fromEnvironment('CAPTURE_REFERENCE'));
}
