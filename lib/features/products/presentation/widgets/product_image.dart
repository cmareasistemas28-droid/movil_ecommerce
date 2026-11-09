import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.height = 160,
    this.imageIndex = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });
  final Product product;
  final double height;
  final int imageIndex;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: product.imageAssets.isEmpty ? ShopColors.mint : Colors.white,
      borderRadius: borderRadius,
    ),
    child: Image.asset(
      product.imageAssets.isEmpty
          ? 'assets/images/products/${product.art}.png'
          : product.imageAssets[imageIndex],
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
