import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/app/app.dart';
import 'package:cibermax_movil/app/store/shop_scope.dart';
import 'package:cibermax_movil/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('profile tab opens guest profile and returns to store', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil'), findsOneWidget);
    expect(find.text('Hola, visitante'), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search and categories filter the catalog', (tester) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'inexistente');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('No encontramos productos'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('No encontramos productos'), findsOneWidget);
    await tester.ensureVisible(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Limpiar búsqueda'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Cables'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Cable USB-C trenzado'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Cable USB-C trenzado'), findsOneWidget);
    expect(find.text('Parlantes Studio 2.0'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail, favorite, cart quantities, removal and demo checkout', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Parlantes Studio 2.0'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Parlantes Studio 2.0'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parlantes Studio 2.0'));
    await tester.pumpAndSettle();
    expect(find.text('Descripción'), findsOneWidget);
    await tester.tap(
      find.byTooltip('Agregar a favoritos: Parlantes Studio 2.0'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ver carrito, 1 productos'));
    await tester.pumpAndSettle();
    expect(find.text('Mi carrito'), findsOneWidget);
    expect(find.text('S/ 144.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Aumentar cantidad'));
    await tester.pumpAndSettle();
    expect(find.text('S/ 273.00'), findsOneWidget);
    await tester.tap(find.text('Continuar compra · S/ 273.00'));
    await tester.pumpAndSettle();
    expect(find.text('Estás en una demostración'), findsOneWidget);
    await tester.tap(find.text('Entendido'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Eliminar Parlantes Studio 2.0'));
    await tester.pumpAndSettle();
    expect(find.text('Tu próximo upgrade te espera'), findsOneWidget);
    await tester.tap(find.text('Explorar productos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    final shop = ShopScope.of(tester.element(find.byType(HomePage)));
    expect(shop.isFavorite('audio-01'), isTrue);
    expect(shop.cartCount, 0);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(375, 812),
    const Size(812, 375),
    const Size(1024, 1366),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'layouts fit $size at text scale $scale with reduced motion',
        (tester) async {
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
          final context = tester.element(find.byType(HomePage));
          final shop = ShopScope.of(context);
          Navigator.of(context)
              .pushNamed('/product', arguments: shop.products.first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.fling(
            find.byType(ListView),
            const Offset(0, -1500),
            3000,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          shop.add(shop.products.first);
          Navigator.of(context).pushNamed('/cart');
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.fling(
            find.byType(ListView).last,
            const Offset(0, -1200),
            3000,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
