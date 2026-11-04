import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/extensions/money.dart';
import '../../domain/entities/product.dart';
import 'favorite_button.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final full = shop.quantityOf(product.id) >= product.stock;
    void open() => Navigator.pushNamed(context, '/product', arguments: product);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: open,
                  child: ProductImage(product: product, height: 132),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: FavoriteButton(product: product),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: open,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 52),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: ShopColors.green,
                      ),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: ShopColors.muted,
                        ),
                      ),
                      Text(
                        '· ${product.category}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: ShopColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.oldPriceCents != null)
                              Text(
                                soles(product.oldPriceCents!),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ShopColors.muted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              soles(product.priceCents),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        tooltip: full
                            ? 'Stock máximo en el carrito'
                            : 'Agregar ${product.name}',
                        onPressed: full
                            ? null
                            : () {
                                shop.add(product);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} agregado al carrito',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Ver carrito',
                                      onPressed: () =>
                                          Navigator.pushNamed(context, '/cart'),
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.add, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
