import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class DiscoveryCategories extends StatelessWidget {
  const DiscoveryCategories({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _CategoryCard(
                label: 'Restaurante',
                asset: 'restaurant.png',
                color: ReferenceColors.restaurant,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _CategoryCard(
                label: 'Taxi',
                asset: 'taxi.png',
                color: ReferenceColors.taxi,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final category in const [
              ('Eventos', 'events.png'),
              ('Licorería', 'liquor.png'),
              ('Supermercado', 'market.png'),
              ('Farmacia', ''),
            ]) ...[
              SizedBox(
                width: 92,
                child: _CategoryCard(
                  label: category.$1,
                  asset: category.$2,
                  color: ReferenceColors.tile,
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    ],
  );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.asset,
    required this.color,
    this.compact = false,
  });
  final String label;
  final String asset;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    excludeSemantics: true,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(compact ? 20 : 16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (asset.isNotEmpty)
            Image.asset(
              'assets/images/reference/$asset',
              height: compact ? 62 : 106,
              width: double.infinity,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            )
          else
            const SizedBox(
              height: 62,
              child: Center(
                child: Icon(
                  Icons.medication_rounded,
                  color: Color(0xFFAA74DF),
                  size: 42,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              4,
              compact ? 2 : 4,
              4,
              compact ? 8 : 12,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ReferenceColors.ink,
                fontSize: compact ? 15 : 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class DiscoveryPromotions extends StatelessWidget {
  const DiscoveryPromotions({super.key, required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 32, right: 24),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Llama Promos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Ver todo',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            for (final promo in const [
              ('candy-promo.png', 'Candy House'),
              ('braza-promo.png', 'La Braza'),
            ]) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/reference/${promo.$1}',
                  width: 154,
                  height: 93,
                  fit: BoxFit.cover,
                  semanticLabel: 'Promoción ${promo.$2}',
                ),
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    ],
  );
}
