import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/instant_page_route.dart';
import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shop_bottom_navigation.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../products/presentation/pages/catalog_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/widgets/customer_drawer.dart';
import '../../../addresses/presentation/pages/addresses_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../reviews/presentation/pages/my_reviews_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _profilePreviewSignedIn = false;
  bool _showProfile = false;
  bool _dark = false;
  bool _drawerOpen = false;
  int _selectedIndex = 0;

  void _selectDestination(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == 4) {
      setState(() => _drawerOpen = true);
      return;
    }
    setState(() {
      _drawerOpen = false;
      _showProfile = false;
      _selectedIndex = index;
    });
  }

  void _openProfile() {
    setState(() {
      _drawerOpen = false;
      _showProfile = true;
    });
  }

  void _closeMenu() => setState(() => _drawerOpen = false);

  void _signInPreview() {
    setState(() {
      _profilePreviewSignedIn = true;
      _showProfile = false;
      _drawerOpen = true;
    });
  }

  void _signOutPreview() {
    setState(() {
      _drawerOpen = false;
      _profilePreviewSignedIn = false;
      _showProfile = true;
    });
  }

  void _backToHome() => setState(() {
    _drawerOpen = false;
    _showProfile = false;
    _selectedIndex = 0;
  });

  void _openCatalog({bool favorites = false}) {
    _closeMenu();
    Navigator.of(context).push(
      InstantPageRoute<void>(
        builder: (_) => Theme(
          data: AppTheme.reference(dark: _dark),
          child: CatalogPage(favorites: favorites),
        ),
      ),
    );
  }

  void _openAccount(Widget page) {
    _closeMenu();
    Navigator.of(context).push<void>(
      InstantPageRoute<void>(
        builder: (_) => Theme(
          data: AppTheme.reference(dark: _dark),
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: AppTheme.reference(dark: _dark),
    child: Builder(
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: _dark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: colors.surface,
            systemNavigationBarIconBrightness: _dark
                ? Brightness.light
                : Brightness.dark,
          ),
          child: PopScope(
            canPop: !_drawerOpen && !_showProfile && _selectedIndex == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) {
                if (_drawerOpen) {
                  _closeMenu();
                } else {
                  _backToHome();
                }
              }
            },
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    excluding: _drawerOpen,
                    child: IgnorePointer(
                      ignoring: _drawerOpen,
                      child: _showProfile
                          ? ProfilePage(
                              onBack: _backToHome,
                              isSignedIn: _profilePreviewSignedIn,
                              onGoogleSignIn: _signInPreview,
                              onSignOut: _signOutPreview,
                            )
                          : _selectedIndex == 1
                          ? const ProductsPage()
                          : _selectedIndex == 2
                          ? CartPage(
                              onExplore: () => _selectDestination(1),
                              onOrderPlaced: () => _selectDestination(3),
                            )
                          : _selectedIndex == 3
                          ? const OrdersPage()
                          : const SizedBox.expand(key: Key('empty-home')),
                    ),
                  ),
                  if (_drawerOpen)
                    Positioned.fill(
                      child: CustomerDrawer(
                        isSignedIn: _profilePreviewSignedIn,
                        onProfile: _openProfile,
                        onClose: _closeMenu,
                        onSignIn: _signInPreview,
                        onSignOut: _signOutPreview,
                        onFavorites: () => _openCatalog(favorites: true),
                        onAddresses: () => _openAccount(const AddressesPage()),
                        onNotifications: () =>
                            _openAccount(const NotificationsPage()),
                        onOrders: () => _selectDestination(3),
                        onReviews: () => _openAccount(const MyReviewsPage()),
                        isDark: _dark,
                        onToggleTheme: () => setState(() => _dark = !_dark),
                      ),
                    ),
                ],
              ),
              bottomNavigationBar: ShopBottomNavigation(
                selectedIndex: _showProfile || _drawerOpen ? 4 : _selectedIndex,
                onSelected: _selectDestination,
                cartCount: ShopScope.of(context).cartCount,
              ),
            ),
          ),
        );
      },
    ),
  );
}
