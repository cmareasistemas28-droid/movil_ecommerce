import 'package:flutter/material.dart';

import '../../../../app/router/instant_page_route.dart';
import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../cart/presentation/widgets/cart_button.dart';
import '../../../products/presentation/pages/catalog_page.dart';
import '../../domain/entities/product_category.dart';
import '../widgets/category_browse_tile.dart';

class SubcategoriesPage extends StatelessWidget {
  const SubcategoriesPage({super.key, required this.category});
  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final subcategories = shop.subcategoriesForCategory(category.id);
    void openProducts([String? subcategoryId]) {
      final theme = Theme.of(context);
      Navigator.of(context).push(
        InstantPageRoute<void>(
          builder: (_) => Theme(
            data: theme,
            child: CatalogPage(
              categoryId: category.id,
              subcategoryId: subcategoryId,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text(category.name),
        actions: const [CartButton(), SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: ShopWidth(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              CategoryBrowseTile(
                key: const Key('category-view-all'),
                title: 'Ver todos los productos',
                subtitle: catalogProductCount(
                  shop.productsForCategory(category.id).length,
                ),
                icon: Icons.grid_view_outlined,
                highlight: true,
                onTap: openProducts,
              ),
              const SizedBox(height: 24),
              Text(
                'Subcategorías',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              for (final subcategory in subcategories)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CategoryBrowseTile(
                    key: ValueKey('subcategory-${subcategory.id}'),
                    title: subcategory.name,
                    subtitle: catalogProductCount(
                      shop.productsForSubcategory(subcategory.id).length,
                    ),
                    icon: catalogIconFor(subcategory.id),
                    onTap: () => openProducts(subcategory.id),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
