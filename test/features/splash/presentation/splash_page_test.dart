import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/app/app.dart';
import 'package:cibermax_movil/features/home/presentation/pages/home_page.dart';
import 'package:cibermax_movil/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets(
    'logo fades and scales, then home replaces splash in 500 milliseconds',
    (tester) async {
      expect(
        SplashPage.animationDuration + SplashPage.transitionDuration,
        const Duration(milliseconds: 500),
      );
      Future<void> advance(int milliseconds) async {
        for (var elapsed = 0; elapsed < milliseconds; elapsed += 5) {
          await tester.pump(const Duration(milliseconds: 5));
        }
      }

      await tester.pumpWidget(const CibermaxApp());
      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      final fade = find.byKey(const Key('splash-fade'));
      expect(tester.widget<FadeTransition>(fade).opacity.value, 0);
      await advance(100);
      expect(
        tester.widget<FadeTransition>(fade).opacity.value,
        greaterThan(0.9),
      );
      expect(
        tester
            .widget<ScaleTransition>(
              find
                  .descendant(of: fade, matching: find.byType(ScaleTransition))
                  .first,
            )
            .scale
            .value,
        greaterThan(0.94),
      );
      await advance(275);
      expect(tester.widget<FadeTransition>(fade).opacity.value, lessThan(0.5));
      await advance(25);
      await tester.pump();
      await advance(100);
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
      expect(
        ModalRoute.of(tester.element(find.byType(HomePage)))!.animation!.value,
        // Allow the single 5 ms frame that starts the destination ticker.
        closeTo(1, 0.06),
      );
      // Settle route disposal after the final rendered animation frame.
      await tester.pumpAndSettle();
      expect(find.byType(SplashPage), findsNothing);
      final context = tester.element(find.byType(HomePage));
      expect(Navigator.of(context).canPop(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('disposing splash stops the ticker and does not navigate later', (
    tester,
  ) async {
    await tester.pumpWidget(const CibermaxApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion uses a static logo and still reaches home', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(const CibermaxApp());
    expect(find.byKey(const Key('splash-fade')), findsNothing);
    expect(find.image(const AssetImage(SplashPage.logoAsset)), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
