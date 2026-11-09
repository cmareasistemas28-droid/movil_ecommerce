import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/app/app.dart';
import 'package:cibermax_movil/app/store/shop_scope.dart';
import 'package:cibermax_movil/features/home/presentation/pages/home_page.dart';
import 'package:cibermax_movil/features/cart/presentation/pages/cart_page.dart';
import 'package:cibermax_movil/features/products/presentation/pages/products_page.dart';
import 'package:cibermax_movil/features/orders/presentation/pages/orders_page.dart';
import 'package:cibermax_movil/features/products/presentation/widgets/product_card.dart';
import 'package:cibermax_movil/features/products/presentation/widgets/product_image.dart';
import 'package:cibermax_movil/features/profile/presentation/widgets/customer_drawer.dart';

Future<void> openMenu(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(NavigationDestination, 'Perfil'));
  await tester.pump();
  expect(tester.getTopLeft(find.byType(CustomerDrawer)), Offset.zero);
}

Future<void> tapVisible(WidgetTester tester, Finder target) async {
  await Scrollable.ensureVisible(tester.element(target), alignment: .5);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> previewSignIn(WidgetTester tester) async {
  await openMenu(tester);
  await tester.scrollUntilVisible(
    find.text('Continuar con Google'),
    120,
    scrollable: find.descendant(
      of: find.byType(CustomerDrawer),
      matching: find.byType(Scrollable),
    ),
  );
  await tapVisible(tester, find.text('Continuar con Google'));
  await tester.pumpAndSettle();
}

Future<void> openCatalog(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(NavigationDestination, 'Productos'));
  await tester.pumpAndSettle();
}

Future<void> selectCatalogFilter(
  WidgetTester tester,
  String prefix,
  String id,
) async {
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

void main() {
  testWidgets('favorites show only saved products and update when removed', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    shop.toggleFavorite('hp-smart-tank-315');
    shop.toggleFavorite('epson-ecotank-l3110');
    expect(find.byKey(const Key('empty-home')), findsOneWidget);
    await previewSignIn(tester);
    await tester.scrollUntilVisible(
      find.text('Mis favoritos'),
      120,
      scrollable: find.descendant(
        of: find.byType(CustomerDrawer),
        matching: find.byType(Scrollable),
      ),
    );
    await tapVisible(tester, find.text('Mis favoritos'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Categorías'), findsNothing);
    expect(find.text('Subcategorías'), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(
      tester
          .widgetList<ProductCard>(find.byType(ProductCard))
          .map((card) => card.product.id)
          .toSet(),
      {'hp-smart-tank-315', 'epson-ecotank-l3110'},
    );
    for (final name in [
      'Impresora HP Smart Tank 315',
      'Impresora Epson EcoTank L3110',
    ]) {
      final heart = find.byTooltip('Quitar de favoritos: $name');
      await Scrollable.ensureVisible(tester.element(heart), alignment: .5);
      await tester.pumpAndSettle();
      await tester.tap(heart);
      await tester.pumpAndSettle();
    }
    expect(find.byType(ProductCard), findsNothing);
    expect(find.text('Guarda lo que te gusta'), findsOneWidget);
    expect(
      find.text('Toca el corazón de un producto para guardarlo aquí.'),
      findsOneWidget,
    );
    expect(shop.isFavorite('hp-smart-tank-315'), isFalse);
    expect(shop.isFavorite('epson-ecotank-l3110'), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'uploaded printers have photos, gallery and searchable demo copies',
    (tester) async {
      await tester.pumpWidget(const CibermaxApp());
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NavigationDestination, 'Productos'));
      await tester.pumpAndSettle();
      await selectCatalogFilter(tester, 'catalog-category', 'impresoras');
      expect(find.text('80 productos'), findsOneWidget);
      final catalogScroll = find
          .descendant(
            of: find.byKey(const Key('catalog-scroll')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Impresora HP Smart Tank 315'),
        120,
        scrollable: catalogScroll,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Impresora HP Smart Tank 315')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Impresora HP Smart Tank 315'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<ProductImage>(find.byType(ProductImage))
            .product
            .priceCents,
        65000,
      );
      expect(
        tester.widget<ProductImage>(find.byType(ProductImage)).imageIndex,
        0,
      );
      await Scrollable.ensureVisible(
        tester.element(find.byKey(const ValueKey('product-photo-1'))),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('product-photo-1')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<ProductImage>(find.byType(ProductImage)).imageIndex,
        1,
      );
      tester
          .state<ScrollableState>(
            find
                .descendant(
                  of: find.byKey(const Key('detail-scroll')),
                  matching: find.byType(Scrollable),
                )
                .first,
          )
          .position
          .jumpTo(0);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('hp-smart-tank-515-demo-20')),
        280,
        maxScrolls: 100,
        scrollable: catalogScroll,
      );
      expect(
        find.byKey(const ValueKey('hp-smart-tank-515-demo-20')),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.byType(TextField),
        -300,
        maxScrolls: 100,
        scrollable: catalogScroll,
      );
      await tester.enterText(
        find.byType(TextField),
        'HP Smart Tank 515 Wi-Fi · Demo 20',
      );
      await tester.pumpAndSettle();
      expect(find.text('1 producto'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('hp-smart-tank-515-demo-20')),
        100,
        scrollable: catalogScroll,
      );
      expect(
        tester
            .widgetList<ProductCard>(find.byType(ProductCard))
            .map((card) => card.product.id),
        ['hp-smart-tank-515-demo-20'],
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'products filters scroll in one row and update subcategories in place',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(const CibermaxApp());
      await tester.pumpAndSettle();
      await openCatalog(tester);
      expect(find.text('80 productos'), findsOneWidget);
      final categoriesScroll = find.descendant(
        of: find.byKey(const Key('catalog-categories-row')),
        matching: find.byType(Scrollable),
      );
      expect(
        tester.getCenter(find.byKey(const ValueKey('catalog-category-all'))).dy,
        tester
            .getCenter(find.byKey(const ValueKey('catalog-category-cables')))
            .dy,
      );
      await tester.drag(categoriesScroll, const Offset(-250, 0));
      await tester.pumpAndSettle();
      expect(
        tester.state<ScrollableState>(categoriesScroll).position.pixels,
        greaterThan(0),
      );
      await selectCatalogFilter(tester, 'catalog-category', 'impresoras');
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const ValueKey('catalog-subcategory-all')),
            )
            .selected,
        isTrue,
      );
      await selectCatalogFilter(
        tester,
        'catalog-subcategory',
        'multifuncionales',
      );
      expect(find.text('40 productos'), findsOneWidget);
      expect(
        tester
            .widgetList<ProductCard>(find.byType(ProductCard))
            .every((card) => card.product.subcategoryId == 'multifuncionales'),
        isTrue,
      );
      await selectCatalogFilter(
        tester,
        'catalog-subcategory',
        'impresoras-wifi',
      );
      expect(find.text('40 productos'), findsOneWidget);
      expect(
        tester
            .widgetList<ProductCard>(find.byType(ProductCard))
            .every((card) => card.product.subcategoryId == 'impresoras-wifi'),
        isTrue,
      );
      await tester.enterText(find.byType(TextField), 'L3160');
      await tester.pumpAndSettle();
      expect(find.text('20 productos'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pumpAndSettle();
      expect(find.text('No encontramos productos'), findsOneWidget);
      await tester.tap(find.byTooltip('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      await selectCatalogFilter(tester, 'catalog-category', 'perifericos');
      await selectCatalogFilter(tester, 'catalog-subcategory', 'mouse');
      expect(find.text('Aún no hay productos'), findsOneWidget);
      expect(find.byType(ProductCard), findsNothing);
      await selectCatalogFilter(tester, 'catalog-category', 'impresoras');
      expect(find.text('80 productos'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const ValueKey('catalog-subcategory-all')),
            )
            .selected,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('bottom destinations keep navigation and open the profile menu', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    expect(find.byTooltip('Abrir menú'), findsNothing);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.byKey(const Key('empty-home')), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byTooltip('Ver carrito, 0 productos'), findsNothing);
    expect(find.byType(StretchingOverscrollIndicator), findsNothing);
    expect(find.byType(GlowingOverscrollIndicator), findsNothing);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
    await tester.tap(find.widgetWithText(NavigationDestination, 'Productos'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductsPage), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    await tester.tap(find.text('Carrito'));
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.text('Explorar productos'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    expect(find.byType(ProductsPage), findsOneWidget);

    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    shop.add(shop.products.first);
    await tester.tap(find.text('Carrito'));
    await tester.pumpAndSettle();
    expect(find.text(shop.products.first.name), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.text('Pedidos'));
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);
    await openMenu(tester);
    expect(find.byType(CustomerDrawer), findsOneWidget);
    expect(
      tester.getSize(find.byType(Drawer)).width,
      tester.view.physicalSize.width / tester.view.devicePixelRatio,
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.byTooltip('Cerrar menú'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
    expect(find.byType(OrdersPage), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile editing, locked email, date, password and logout', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty-home')), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await previewSignIn(tester);
    expect(find.text('Jack Perez'), findsOneWidget);
    await tapVisible(tester, find.text('Mi perfil'));
    await tester.pump();
    expect(find.text('JP'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    expect(find.text('Fecha de registro'), findsNothing);
    expect(find.byKey(const ValueKey('profile-field-Código')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('profile-field-Nombres')));
    await tester.pump();
    final editorRoute = ModalRoute.of(
      tester.element(find.text('Guardar nombres')),
    )!;
    expect(editorRoute.animation!.value, 1);
    expect(editorRoute.transitionDuration, Duration.zero);
    expect(editorRoute.reverseTransitionDuration, Duration.zero);
    await tester.enterText(find.byType(TextField), 'Jack Daniel');
    await tester.tap(find.text('Guardar nombres'));
    await tester.pumpAndSettle();
    expect(find.text('Jack Daniel Perez'), findsOneWidget);

    Future<void> revealField(String title) async {
      final field = find.byKey(ValueKey('profile-field-$title'));
      await tester.scrollUntilVisible(
        field,
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await Scrollable.ensureVisible(tester.element(field), alignment: .5);
      await tester.pumpAndSettle();
    }

    await revealField('Tipo de documento');
    await tester.tap(
      find.byKey(const ValueKey('profile-field-Tipo de documento')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('CIP'));
    await tester.enterText(find.byType(TextField), '12345678');
    await tester.tap(find.text('Guardar documento'));
    await tester.pumpAndSettle();
    expect(find.text('CIP'), findsOneWidget);
    expect(find.text('12345678'), findsOneWidget);

    await revealField('Número de documento');
    await tester.tap(
      find.byKey(const ValueKey('profile-field-Número de documento')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('DNI'));
    await tester.enterText(find.byType(TextField), '99999999');
    await tester.tap(find.byTooltip('Volver al perfil'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('profile-field-Tipo de documento')),
      -100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('CIP'), findsOneWidget);
    expect(find.text('12345678'), findsOneWidget);
    expect(find.text('99999999'), findsNothing);

    await revealField('Fecha de nacimiento');
    await tester.tap(
      find.byKey(const ValueKey('profile-field-Fecha de nacimiento')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('birth-date-input')));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.ensureVisible(find.text('Guardar fecha de nacimiento'));
    await tester.tap(find.text('Guardar fecha de nacimiento'));
    await tester.pumpAndSettle();
    await revealField('Edad');
    expect(find.text('18 años'), findsOneWidget);

    await revealField('Correo electrónico');
    expect(find.text('jackdev2399@gmail.com'), findsOneWidget);
    final email = find.byKey(
      const ValueKey('profile-field-Correo electrónico'),
    );
    expect(
      tester
          .widget<InkWell>(
            find.descendant(of: email, matching: find.byType(InkWell)),
          )
          .onTap,
      isNull,
    );
    await tester.tap(email);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    await revealField('Contraseña');
    await tester.tap(find.byKey(const ValueKey('profile-field-Contraseña')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
    await tester.enterText(find.byType(TextField), 'ejemplo-local-123');
    await tester.tap(find.byTooltip('Mostrar contraseña'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isFalse,
    );
    await tester.tap(find.text('Guardar contraseña'));
    await tester.pumpAndSettle();
    expect(find.text('••••••••'), findsOneWidget);
    expect(find.text('ejemplo-local-123'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Cerrar sesión'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.text('Jack Perez'), findsNothing);
    await tapVisible(tester, find.text('Continuar con Google'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil'), findsOneWidget);
    await tester.tap(find.byTooltip('Activar modo oscuro'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(CustomerDrawer))).brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'catalog searches uploaded printers and confirms quick additions',
    (tester) async {
      await tester.pumpWidget(const CibermaxApp());
      await tester.pumpAndSettle();
      await openCatalog(tester);
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pumpAndSettle();
      expect(find.text('No encontramos productos'), findsOneWidget);
      await tester.tap(find.byTooltip('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'HP Smart Tank 515 Wi-Fi');
      await tester.pumpAndSettle();
      expect(find.text('20 productos'), findsOneWidget);
      final add = find.byTooltip('Agregar Impresora HP Smart Tank 515 Wi-Fi');
      await tester.scrollUntilVisible(
        add,
        100,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('catalog-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await Scrollable.ensureVisible(tester.element(add), alignment: .5);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(find.text('Se agregó al carrito').hitTestable(), findsOneWidget);
      expect(
        ShopScope.of(tester.element(find.byKey(const Key('catalog-scroll'))))
            .quantityOf('hp-smart-tank-515'),
        1,
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Se agregó al carrito').hitTestable(), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'product, favorite, address and checkout create a visible order',
    (tester) async {
      await tester.pumpWidget(const CibermaxApp());
      await tester.pumpAndSettle();
      await openCatalog(tester);
      await tester.scrollUntilVisible(
        find.text('Impresora HP Smart Tank 315'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Impresora HP Smart Tank 315')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Impresora HP Smart Tank 315'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byTooltip('Agregar a favoritos: Impresora HP Smart Tank 315'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('detail-add')));
      await tester.pumpAndSettle();
      expect(find.text('Se agregó al carrito').hitTestable(), findsOneWidget);
      expect(find.text('Ver carrito'), findsNothing);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Se agregó al carrito').hitTestable(), findsNothing);
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NavigationDestination, 'Carrito'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('place-order')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Agregar dirección'));
      await tester.pumpAndSettle();
      for (var index = 0; index < 4; index++) {
        await tester.enterText(
          find.byKey(ValueKey('address-field-$index')),
          const ['Junín', 'Huancayo', 'Huancayo', 'Jr. Lima 123'][index],
        );
      }
      await tester.ensureVisible(find.byKey(const Key('save-address')));
      await tester.tap(find.byKey(const Key('save-address')));
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.byTooltip('Aumentar cantidad')),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      expect(find.text('Realizar compra · S/ 650.00'), findsOneWidget);
      await tester.tap(find.byTooltip('Aumentar cantidad'));
      await tester.pumpAndSettle();
      expect(find.text('Realizar compra · S/ 1300.00'), findsOneWidget);
      await tester.tap(find.byTooltip('Disminuir cantidad'));
      await tester.pumpAndSettle();
      expect(find.text('Realizar compra · S/ 650.00'), findsOneWidget);
      await tester.tap(find.byTooltip('Aumentar cantidad'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Realizar compra · S/ 1300.00'));
      await tester.pumpAndSettle();
      expect(find.byType(OrdersPage), findsOneWidget);
      final shop = ShopScope.of(tester.element(find.byType(HomePage)));
      expect(shop.isFavorite('hp-smart-tank-315'), isTrue);
      expect(shop.cartCount, 0);
      expect(shop.orders.length, 1);
      expect(shop.orders.single.totalCents, 130000);
      expect(shop.notifications.single.title, 'Pedido realizado');
      await tester.tap(find.text('Ver detalle'));
      await tester.pumpAndSettle();
      expect(find.text('Detalle del pedido'), findsOneWidget);
      expect(find.text('Jr. Lima 123'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('2 × S/ 650.00'),
        200,
        scrollable: find
            .descendant(
              of: find.byKey(
                const PageStorageKey('account-Detalle del pedido'),
              ),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('2 × S/ 650.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('detail total follows quantity and respects remaining stock', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    final product = shop.products.firstWhere(
      (product) => product.id == 'hp-smart-tank-315',
    );
    shop.add(product, product.stock - 5);
    Navigator.of(tester.element(find.byType(HomePage)))
        .pushNamed('/product', arguments: product);
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsNothing);
    expect(
      tester.widget<Text>(find.byKey(const Key('detail-total'))).data,
      'S/ 650.00',
    );
    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.remove))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('Aumentar cantidad'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('detail-total'))).data,
      'S/ 1300.00',
    );
    await tester.tap(find.byKey(const Key('detail-add')));
    await tester.pumpAndSettle();
    expect(shop.quantityOf(product.id), product.stock - 3);
    expect(
      tester.widget<Text>(find.byKey(const Key('detail-total'))).data,
      'S/ 650.00',
    );
    // Only three units remain; the selector cannot exceed them.
    await tester.tap(find.byTooltip('Aumentar cantidad'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Aumentar cantidad'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('detail-total'))).data,
      'S/ 1950.00',
    );
    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.add))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('detail-add')));
    await tester.pumpAndSettle();
    expect(shop.quantityOf(product.id), product.stock);
    expect(find.text('Se agregó al carrito').hitTestable(), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Se agregó al carrito').hitTestable(), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('detail-add')))
          .onPressed,
      isNull,
    );
    expect(find.text('Stock máximo en tu carrito'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(375, 812),
    const Size(812, 375),
    const Size(1024, 1366),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('reference layouts fit $size at text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            const FakeAccessibilityFeatures(disableAnimations: true);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
        });
        await tester.pumpWidget(const CibermaxApp());
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(
          find.widgetWithText(NavigationDestination, 'Productos'),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await selectCatalogFilter(tester, 'catalog-category', 'impresoras');
        await selectCatalogFilter(
          tester,
          'catalog-subcategory',
          'multifuncionales',
        );
        await tester.scrollUntilVisible(
          find.text('Impresora HP Smart Tank 315'),
          80,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('catalog-scroll')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.text('Impresora HP Smart Tank 315'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await Scrollable.ensureVisible(
          tester.element(find.text('Impresora HP Smart Tank 315')),
          alignment: .5,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Impresora HP Smart Tank 315'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final detailScroll = find
            .descendant(
              of: find.byKey(const Key('detail-scroll')),
              matching: find.byType(Scrollable),
            )
            .first;
        await tester.scrollUntilVisible(
          find.text('Reseñas'),
          200,
          maxScrolls: 100,
          scrollable: detailScroll,
        );
        expect(
          find.text('Comparte tu experiencia con este producto.'),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('detail-add')).hitTestable(),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        tester.state<ScrollableState>(detailScroll).position.jumpTo(0);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        final cartShop = ShopScope.of(tester.element(find.byType(HomePage)));
        cartShop.add(
          cartShop.products.firstWhere(
            (product) => product.id == 'hp-smart-tank-515-demo-20',
          ),
        );
        await tester.tap(find.text('Carrito'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.widgetWithText(NavigationDestination, 'Pedidos'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Inicio'));
        await tester.pumpAndSettle();
        await previewSignIn(tester);
        expect(tester.takeException(), isNull);
        final drawerScroll = find.descendant(
          of: find.byType(CustomerDrawer),
          matching: find.byType(Scrollable),
        );
        await tester.scrollUntilVisible(
          find.text('Libro de reclamaciones'),
          100,
          maxScrolls: 100,
          scrollable: drawerScroll,
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Cerrar menú'));
        await tester.pumpAndSettle();
        await openMenu(tester);
        await tester.drag(drawerScroll, const Offset(0, 10000));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Mi perfil'),
          100,
          scrollable: drawerScroll,
        );
        await tapVisible(tester, find.text('Mi perfil'));
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
        await tester.ensureVisible(find.text('Guardar documento'));
        expect(tester.takeException(), isNull);
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
        await tester.ensureVisible(find.byKey(const Key('birth-date-input')));
        await tester.tap(find.byKey(const Key('birth-date-input')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Guardar fecha de nacimiento'));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Volver al perfil'));
        await tester.pumpAndSettle();
        await tester.fling(
          find.byType(ListView).last,
          const Offset(0, -1200),
          3000,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final context = tester.element(find.byType(HomePage));
        final shop = ShopScope.of(context);
        Navigator.of(context)
            .pushNamed('/product', arguments: shop.products.first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
