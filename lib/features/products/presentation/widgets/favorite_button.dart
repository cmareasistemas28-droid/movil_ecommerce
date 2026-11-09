import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/reference_circle_button.dart';
import '../../domain/entities/product.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.product, this.size = 44});
  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final selected = shop.isFavorite(product.id);
    return IconButton(
      isSelected: selected,
      tooltip:
          '${selected ? 'Quitar de' : 'Agregar a'} favoritos: ${product.name}',
      onPressed: () => shop.toggleFavorite(product.id),
      icon: Icon(
        Icons.favorite_border_rounded,
        size: 19,
        color: Theme.of(context).colorScheme.primary,
      ),
      selectedIcon: Icon(
        Icons.favorite_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: 19,
      ),
      style: ReferenceCircleButton.styleOf(context, size: size),
    );
  }
}
