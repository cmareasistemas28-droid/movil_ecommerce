import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import 'product_image.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.product,
    required this.height,
    this.overlay,
    this.information,
  });
  final Product product;
  final double height;
  final Widget? overlay;
  final Widget? information;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            child: ProductImage(
              product: widget.product,
              height: widget.height,
              imageIndex: _selected,
              borderRadius: BorderRadius.zero,
            ),
          ),
          if (widget.overlay != null)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: SafeArea(bottom: false, child: widget.overlay!),
            ),
        ],
      ),
      if (widget.information != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: widget.information!,
          ),
        ),
      if (widget.product.imageAssets.length > 1) ...[
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (
              var index = 0;
              index < widget.product.imageAssets.length;
              index++
            )
              Semantics(
                button: true,
                selected: _selected == index,
                label:
                    'Ver foto ${index + 1} de ${widget.product.imageAssets.length}',
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selected == index
                          ? ReferenceColors.accent
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: _selected == index ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey('product-photo-$index'),
                    onTap: () => setState(() => _selected = index),
                    child: SizedBox(
                      width: 64,
                      height: 52,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          widget.product.imageAssets[index],
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    ],
  );
}
