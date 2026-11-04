import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../cart/presentation/widgets/cart_button.dart';
import '../../../cart/presentation/widgets/quantity_selector.dart';
import '../../domain/entities/product.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_image.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final shop = ShopScope.of(context);
    final available = product.stock - shop.quantityOf(product.id);
    final selected = available > 0 ? _quantity.clamp(1, available) : 0;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Detalle'),
        actions: const [CartButton(), SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: ShopWidth(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ProductImage(
                product: product,
                height: MediaQuery.sizeOf(context).height < 500 ? 180 : 280,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                        color: ShopColors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        FavoriteButton(product: product),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _Fact(
                          icon: Icons.star_rounded,
                          text: '${product.rating} · Valoración demo',
                        ),
                        _Fact(
                          icon: Icons.verified_outlined,
                          text: '${product.stock} disponibles',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 32),
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.oldPriceCents != null)
                              Text(
                                soles(product.oldPriceCents!),
                                style: const TextStyle(
                                  color: ShopColors.muted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              soles(product.priceCents),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        if (available > 0)
                          QuantitySelector(
                            value: selected,
                            max: available,
                            onChanged: (value) =>
                                setState(() => _quantity = value),
                          )
                        else
                          const Text('Stock máximo en tu carrito'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: ShopColors.muted),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Especificaciones',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (final spec in product.specifications.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            Text(
                              '${spec.key}:',
                              style: const TextStyle(color: ShopColors.muted),
                            ),
                            Text(
                              spec.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Producto e información de demostración.',
                      style: TextStyle(fontSize: 12, color: ShopColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: ShopWidth(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: FilledButton.icon(
              key: const Key('detail-add'),
              onPressed: available <= 0
                  ? null
                  : () {
                      shop.add(product, selected);
                      setState(() => _quantity = 1);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$selected × ${product.name} en tu carrito',
                          ),
                          action: SnackBarAction(
                            label: 'Ver carrito',
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cart'),
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Agregar al carrito', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: ShopColors.green),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: ShopColors.muted),
        ),
      ),
    ],
  );
}
