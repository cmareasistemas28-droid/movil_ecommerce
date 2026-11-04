import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../cart/presentation/widgets/cart_button.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/promo_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _category = 'Todos';
  String _query = '';
  bool _favorites = false;
  bool _profile = false;

  void _reset({bool favorites = false}) => setState(() {
    _favorites = favorites;
    _profile = false;
    _category = 'Todos';
    _query = '';
    _searchController.clear();
  });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final products = shop.products
        .where(
          (p) =>
              (_category == 'Todos' || p.category == _category) &&
              (!_favorites || shop.isFavorite(p.id)) &&
              '${p.name} ${p.category}'.toLowerCase().contains(
                _query.toLowerCase().trim(),
              ),
        )
        .toList();
    final showPromo = !_favorites && _query.isEmpty && _category == 'Todos';
    return Scaffold(
      body: _profile
          ? ProfilePage(onExplore: _reset)
          : SafeArea(
              child: ShopWidth(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: ShopColors.green,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Entrega de referencia',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ShopColors.muted,
                                        ),
                                      ),
                                      Text(
                                        'Lima, Perú',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CartButton(),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'cibermax.',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: ShopColors.green,
                                    fontSize: 28,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Conecta con lo que te gusta.'),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _searchController,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                labelText: 'Buscar productos',
                                hintText: 'Cables, parlantes, componentes…',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Limpiar búsqueda',
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _query = '');
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                              ),
                            ),
                            if (showPromo) ...[
                              const SizedBox(height: 16),
                              PromoBanner(
                                onExplore: () =>
                                    setState(() => _category = 'Audio'),
                              ),
                            ],
                            const SizedBox(height: 16),
                            // Native chips retain large touch targets and wrap for large fonts.
                            Wrap(
                              spacing: 8,
                              runSpacing: 0,
                              children: [
                                for (final category in [
                                  'Todos',
                                  'Componentes',
                                  'Cables',
                                  'Audio',
                                  'Periféricos',
                                ])
                                  ChoiceChip(
                                    label: Text(category),
                                    selected: _category == category,
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      color: _category == category
                                          ? Colors.white
                                          : ShopColors.muted,
                                      fontSize: 13,
                                    ),
                                    onSelected: (_) =>
                                        setState(() => _category = category),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  _favorites ? 'Tus favoritos' : 'Destacados',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  '${products.length} productos',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (products.isEmpty)
                      SliverToBoxAdapter(
                        child: EmptyState(
                          icon: _favorites
                              ? Icons.favorite_border
                              : Icons.search_off,
                          title: _favorites
                              ? 'Guarda lo que te gusta'
                              : 'No encontramos productos',
                          message: _favorites
                              ? 'Toca el corazón de un producto para verlo aquí. Revisa también los filtros activos.'
                              : 'Prueba con otra palabra o categoría.',
                          action: TextButton(
                            onPressed: _reset,
                            child: const Text('Ver todos los productos'),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.crossAxisExtent;
                            final scale =
                                MediaQuery.textScalerOf(context).scale(16) / 16;
                            final columns = width < 330 || scale > 1.4
                                ? 1
                                : width >= 700
                                ? 3
                                : 2;
                            return SliverList.builder(
                              itemCount: (products.length / columns).ceil(),
                              itemBuilder: (context, row) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (
                                      var column = 0;
                                      column < columns;
                                      column++
                                    ) ...[
                                      if (column > 0) const SizedBox(width: 12),
                                      Expanded(
                                        child:
                                            row * columns + column <
                                                products.length
                                            ? ProductCard(
                                                product:
                                                    products[row * columns +
                                                        column],
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _profile
            ? 3
            : _favorites
            ? 1
            : 0,
        onDestinationSelected: (index) {
          if (index == 3) {
            setState(() => _profile = true);
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/cart');
            return;
          }
          _reset(favorites: index == 1);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
