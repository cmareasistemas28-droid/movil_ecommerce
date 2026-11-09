import 'package:flutter/material.dart';

import '../../../../app/router/instant_page_route.dart';
import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../widgets/category_browse_tile.dart';
import 'subcategories_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return SafeArea(
      child: ShopWidth(
        child: ListView(
          key: const PageStorageKey('catalog-categories'),
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Categorías',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Elige una categoría para ver sus subcategorías.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            for (final category in shop.categories)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CategoryBrowseTile(
                  key: ValueKey('category-${category.id}'),
                  title: category.name,
                  subtitle:
                      '${shop.subcategoriesForCategory(category.id).length} subcategorías · ${catalogProductCount(shop.productsForCategory(category.id).length)}',
                  icon: catalogIconFor(category.id),
                  onTap: () {
                    final theme = Theme.of(context);
                    Navigator.of(context).push(
                      InstantPageRoute<void>(
                        builder: (_) => Theme(
                          data: theme,
                          child: SubcategoriesPage(category: category),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
