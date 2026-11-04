import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../domain/entities/product.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final selected = shop.isFavorite(product.id);
    return IconButton(
      isSelected: selected,
      tooltip:
          '${selected ? 'Quitar de' : 'Agregar a'} favoritos: ${product.name}',
      onPressed: () => shop.toggleFavorite(product.id),
      icon: const Icon(Icons.favorite_border_rounded),
      selectedIcon: Icon(
        Icons.favorite_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      style: IconButton.styleFrom(backgroundColor: Colors.white),
    );
  }
}
