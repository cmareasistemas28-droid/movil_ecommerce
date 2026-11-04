import 'package:flutter/material.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

abstract final class AppRouter {
  static const splash = '/';
  static const home = '/home';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashPage(destination: home);
      case home:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: SplashPage.transitionDuration,
          pageBuilder: (_, _, _) => const HomePage(),
          transitionsBuilder: (context, animation, _, child) =>
              MediaQuery.disableAnimationsOf(context)
              ? child
              : FadeTransition(opacity: animation, child: child),
        );
      case '/cart':
        page = const CartPage();
      case '/product':
        final product = settings.arguments;
        if (product is! Product) return null;
        page = ProductDetailPage(product: product);
      default:
        return null;
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
