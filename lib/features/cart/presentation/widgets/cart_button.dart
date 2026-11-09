import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = ShopScope.of(context).cartCount;
    return IconButton(
      tooltip: 'Ver carrito, $count productos',
      onPressed: () => Navigator.pushNamed(context, '/cart'),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.shopping_cart_outlined),
      ),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
