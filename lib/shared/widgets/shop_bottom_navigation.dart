import 'package:flutter/material.dart';

import 'shop_layout.dart';

class ShopBottomNavigation extends StatelessWidget {
  const ShopBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.cartCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int cartCount;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .035),
          blurRadius: 12,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: ShopWidth(
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              size: 22,
              color: states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        child: Stack(
          children: [
            NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              elevation: 0,
              height: 64,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Inicio',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Productos',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.shopping_cart_rounded),
                  ),
                  label: 'Carrito',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Pedidos',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Perfil',
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  for (var index = 0; index < 5; index++)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 2,
                          color: index == selectedIndex
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
