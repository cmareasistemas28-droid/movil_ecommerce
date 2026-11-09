import 'package:flutter/material.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'instant_page_route.dart';
import '../../features/products/presentation/pages/catalog_page.dart';
import '../../features/addresses/presentation/pages/addresses_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/reviews/presentation/pages/my_reviews_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';

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
      case '/products':
        page = const CatalogPage();
      case '/addresses':
        page = const AddressesPage();
      case '/orders':
        page = const OrdersPage();
      case '/notifications':
        page = const NotificationsPage();
      case '/my-reviews':
        page = const MyReviewsPage();
      case '/order':
        final id = settings.arguments;
        if (id is! String) return null;
        page = OrderDetailPage(orderId: id);
      case '/product':
        final product = settings.arguments;
        if (product is! Product) return null;
        page = ProductDetailPage(product: product);
      default:
        return null;
    }
    return InstantPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
