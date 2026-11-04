import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../cart/presentation/widgets/cart_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final favorites = shop.products.where((p) => shop.isFavorite(p.id)).length;
    return SafeArea(
      child: ShopWidth(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mi perfil',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const CartButton(),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ShopColors.mint,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: ShopColors.green,
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hola, visitante',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu espacio en Cibermax. Explora y guarda tus próximos favoritos.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tu cuenta', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline_rounded),
                    title: Text('Modo invitado'),
                    subtitle: Text('Sin cuenta vinculada'),
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text('Ubicación de referencia'),
                    subtitle: Text('Lima, Perú'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tu actividad', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.favorite_border),
                    title: const Text('Favoritos guardados'),
                    subtitle: Text('$favorites productos en esta sesión'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text('Mi carrito'),
                    subtitle: Text('${shop.cartCount} productos'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Estás en una demostración. El inicio de sesión y la edición de datos personales todavía no están disponibles. Tu actividad se conserva mientras la app permanece abierta.',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onExplore,
              child: const Text('Volver a la tienda'),
            ),
          ],
        ),
      ),
    );
  }
}
