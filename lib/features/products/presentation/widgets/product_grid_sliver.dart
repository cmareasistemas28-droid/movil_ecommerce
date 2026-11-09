import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import 'product_card.dart';

/// Builds visible product rows on demand, including long demo catalogs.
class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final columns =
          constraints.crossAxisExtent < 330 ||
              MediaQuery.textScalerOf(context).scale(16) > 22
          ? 1
          : constraints.crossAxisExtent >= 700
          ? 3
          : 2;
      return SliverList.builder(
        itemCount: (products.length / columns).ceil(),
        itemBuilder: (context, row) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columns; column++) ...[
                if (column > 0) const SizedBox(width: 12),
                Expanded(
                  child: row * columns + column < products.length
                      ? ProductCard(
                          key: ValueKey(products[row * columns + column].id),
                          product: products[row * columns + column],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
