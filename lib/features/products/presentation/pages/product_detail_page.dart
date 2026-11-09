import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/reference_circle_button.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_surface.dart';
import '../../domain/entities/product.dart';
import '../widgets/cart_added_message.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_purchase_bar.dart';
import '../widgets/product_reviews.dart';
import '../widgets/rating_star.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final Product product;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
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
    final available =
        shop.availableStock(product) - shop.quantityOf(product.id);
    final selected = available > 0 ? _quantity.clamp(1, available) : 0;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: theme.colorScheme.surface,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: ShopWidth(
            child: ListView(
              key: const Key('detail-scroll'),
              padding: EdgeInsets.zero,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => ProductGallery(
                    product: product,
                    height:
                        (constraints.maxWidth * .63).clamp(200.0, 340.0) +
                        MediaQuery.paddingOf(context).top,
                    information: ShopSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            product.name,
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const RatingStar(size: 15),
                              const SizedBox(width: 5),
                              Text(
                                '${product.rating}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (product.oldPriceCents != null)
                                Text(
                                  soles(product.oldPriceCents!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                soles(product.priceCents),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    overlay: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: BackButton(
                            color: theme.colorScheme.onSurface,
                            style: ReferenceCircleButton.styleOf(context),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        FavoriteButton(product: product),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AccountCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Descripción',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      AccountCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Especificaciones',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            for (final spec
                                in product.specifications.entries) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      spec.key,
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      spec.value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          ],
                        ),
                      ),
                      AccountCard(child: ProductReviews(product: product)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ProductPurchaseBar(
          messageController: _cartMessage,
          quantity: selected,
          available: available,
          unitPriceCents: product.priceCents,
          onQuantityChanged: (value) => setState(() => _quantity = value),
          onAdd: available <= 0
              ? null
              : () {
                  shop.add(product, selected);
                  setState(() => _quantity = 1);
                  _cartMessage.show();
                },
        ),
      ),
    );
  }
}
