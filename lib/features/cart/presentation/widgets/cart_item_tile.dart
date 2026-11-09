import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/extensions/money.dart';
import '../../../products/presentation/widgets/product_image.dart';
import '../../domain/entities/shopping_cart.dart';
import 'quantity_selector.dart';
import '../../../../shared/widgets/shop_surface.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ShopSurface(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: ProductImage(product: item.product, height: 88),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        soles(item.product.priceCents),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar ${item.product.name}',
                  onPressed: () => shop.remove(item.product.id),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 24,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    soles(item.totalCents),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                QuantitySelector(
                  value: item.quantity,
                  max: shop.availableStock(item.product),
                  compact: true,
                  onChanged: (value) => shop.setQuantity(item.product, value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
