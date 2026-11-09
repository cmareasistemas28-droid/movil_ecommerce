import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../../shared/widgets/shop_surface.dart';
import '../../../cart/presentation/widgets/cart_button.dart';
import '../widgets/product_grid_sliver.dart';
import '../widgets/catalog_filter_row.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    this.favorites = false,
    this.initialQuery = '',
    this.categoryId,
    this.subcategoryId,
    this.embedded = false,
  }) : assert(subcategoryId == null || categoryId != null);
  final bool favorites;
  final String initialQuery;
  final String? categoryId;
  final String? subcategoryId;
  final bool embedded;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final _search = TextEditingController(
    text: widget.favorites ? '' : widget.initialQuery,
  );
  late String? _categoryId = widget.favorites ? null : widget.categoryId;
  late String? _subcategoryId = widget.favorites ? null : widget.subcategoryId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _selectCategory(String? id) => setState(() {
    _categoryId = id;
    _subcategoryId = null;
  });

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final colors = Theme.of(context).colorScheme;
    final category = _categoryId == null
        ? null
        : shop.categories.firstWhere((category) => category.id == _categoryId);
    final subcategory = _subcategoryId == null
        ? null
        : shop.subcategories.firstWhere(
            (subcategory) => subcategory.id == _subcategoryId,
          );
    final subcategories = _categoryId == null
        ? shop.subcategories
        : shop.subcategoriesForCategory(_categoryId!);
    final products = shop.products
        .where(
          (product) =>
              (!widget.favorites || shop.isFavorite(product.id)) &&
              (_categoryId == null ||
                  shop.categoryFor(product).id == _categoryId) &&
              (_subcategoryId == null ||
                  product.subcategoryId == _subcategoryId) &&
              '${product.name} ${shop.categoryFor(product).name} ${shop.subcategoryFor(product).name}'
                  .toLowerCase()
                  .contains(_search.text.toLowerCase().trim()),
        )
        .toList();
    final searching = _search.text.trim().isNotEmpty || category == null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(
                widget.favorites
                    ? 'Mis favoritos'
                    : subcategory?.name ?? category?.name ?? 'Tienda Cibermax',
              ),
              actions: const [CartButton(), SizedBox(width: 12)],
            ),
      body: SafeArea(
        child: ShopWidth(
          child: CustomScrollView(
            key: const Key('catalog-scroll'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!widget.favorites) ...[
                        if (!widget.embedded && category != null) ...[
                          Text(
                            subcategory == null
                                ? category.name
                                : '${category.name} / ${subcategory.name}',
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ShopSurface(
                          radius: 28,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            controller: _search,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofillHints: null,
                            enableIMEPersonalizedLearning: false,
                            smartDashesType: SmartDashesType.disabled,
                            smartQuotesType: SmartQuotesType.disabled,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Buscar productos',
                              filled: true,
                              fillColor: colors.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: IconButton(
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () => setState(_search.clear),
                                icon: const Icon(Icons.close, size: 18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (widget.categoryId == null) ...[
                          Text(
                            'Categorías',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          CatalogFilterRow(
                            key: const Key('catalog-categories-row'),
                            keyPrefix: 'catalog-category',
                            options: [
                              (id: null, label: 'Todos'),
                              for (final category in shop.categories)
                                (id: category.id, label: category.name),
                            ],
                            selectedId: _categoryId,
                            onSelected: _selectCategory,
                          ),
                          const SizedBox(height: 16),
                        ],
                        ...[
                          Text(
                            'Subcategorías',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          CatalogFilterRow(
                            key: const Key('catalog-subcategories-row'),
                            keyPrefix: 'catalog-subcategory',
                            options: [
                              (id: null, label: 'Todos'),
                              for (final subcategory in subcategories)
                                (id: subcategory.id, label: subcategory.name),
                            ],
                            selectedId: _subcategoryId,
                            onSelected: (id) => setState(() {
                              _subcategoryId = id;
                              if (id != null && _categoryId == null) {
                                _categoryId = shop.subcategories
                                    .firstWhere(
                                      (subcategory) => subcategory.id == id,
                                    )
                                    .categoryId;
                              }
                            }),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                      Text(
                        products.length == 1
                            ? '1 producto'
                            : '${products.length} productos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (products.isEmpty)
                SliverToBoxAdapter(
                  child: EmptyState(
                    icon: widget.favorites
                        ? Icons.favorite_border
                        : Icons.search_off,
                    title: widget.favorites
                        ? 'Guarda lo que te gusta'
                        : searching
                        ? 'No encontramos productos'
                        : 'Aún no hay productos',
                    message: widget.favorites
                        ? 'Toca el corazón de un producto para guardarlo aquí.'
                        : searching
                        ? 'Prueba con otra palabra o categoría.'
                        : 'Todavía no hay productos en esta ${subcategory == null ? 'categoría' : 'subcategoría'}.',
                    action: subcategory == null
                        ? null
                        : TextButton(
                            onPressed: () => setState(() {
                              _subcategoryId = null;
                              _search.clear();
                            }),
                            child: Text('Ver todos de ${category!.name}'),
                          ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: ProductGridSliver(products: products),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
