import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product, this.height = 160});
  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: ShopColors.mint,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Image.asset(
      'assets/images/products/${product.art}.png',
      fit: BoxFit.contain,
      semanticLabel: 'Ilustración de ${product.name}',
      errorBuilder: (_, _, _) => Semantics(
        label: 'Imagen no disponible: ${product.name}',
        child: const Center(
          child: Icon(
            Icons.devices_other_outlined,
            size: 56,
            color: ShopColors.green,
          ),
        ),
      ),
    ),
  );
}
