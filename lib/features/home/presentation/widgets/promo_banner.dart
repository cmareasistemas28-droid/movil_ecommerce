import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ShopColors.yellow,
      borderRadius: BorderRadius.circular(24),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final showArt =
            constraints.maxWidth > 270 &&
            MediaQuery.textScalerOf(context).scale(16) < 24;
        return Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AUDIO DESTACADO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tu música.\nSin límites.',
                    style: TextStyle(
                      fontSize: 23,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: ShopColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      textStyle: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: onExplore,
                    child: const Text('Explorar audio'),
                  ),
                ],
              ),
            ),
            if (showArt)
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/products/headphones.png',
                  height: 160,
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.headphones_outlined,
                    size: 80,
                    color: ShopColors.green,
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}
