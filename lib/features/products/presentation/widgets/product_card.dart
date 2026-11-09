import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/extensions/money.dart';
import '../../domain/entities/product.dart';
import 'cart_added_message.dart';
import 'favorite_button.dart';
import 'product_image.dart';
import 'rating_star.dart';
import '../../../../shared/widgets/shop_surface.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _cartMessage = CartAddedMessageController();

  @override
  void dispose() {
    _cartMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final shop = ShopScope.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final full =
        shop.checkoutInProgress ||
        shop.quantityOf(product.id) >= shop.availableStock(product);
    void open() => Navigator.pushNamed(context, '/product', arguments: product);
    return ShopSurface(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: open,
                  child: ProductImage(product: product, height: 112),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
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
                    constraints: const BoxConstraints(minHeight: 54),
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
                    const RatingStar(size: 16),
                    Text(
                      '${product.rating}',
                      style: TextStyle(fontSize: 11, color: muted),
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
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          else
                            const SizedBox(height: 15),
                          Text(
                            soles(product.priceCents),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: full
                          ? 'Stock máximo en el carrito'
                          : 'Agregar ${product.name}',
                      onPressed: full
                          ? null
                          : () {
                              shop.add(product);
                              _cartMessage.show();
                            },
                      icon: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: full
                              ? Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: .15)
                              : Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CartAddedMessage(controller: _cartMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
