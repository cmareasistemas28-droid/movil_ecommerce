import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/reference_circle_button.dart';
import '../../../../shared/widgets/shop_surface.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({
    super.key,
    required this.isSignedIn,
    required this.onProfile,
    required this.onClose,
    required this.onSignIn,
    required this.onSignOut,
    required this.onFavorites,
    required this.onToggleTheme,
    required this.isDark,
    required this.onAddresses,
    required this.onNotifications,
    required this.onOrders,
    required this.onReviews,
  });
  final bool isSignedIn;
  final bool isDark;
  final VoidCallback onProfile;
  final VoidCallback onClose;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;
  final VoidCallback onFavorites;
  final VoidCallback onToggleTheme;
  final VoidCallback onAddresses;
  final VoidCallback onNotifications;
  final VoidCallback onOrders;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shop = ShopScope.of(context);
    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      shape: const RoundedRectangleBorder(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Perfil',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: isDark
                        ? 'Activar modo claro'
                        : 'Activar modo oscuro',
                    onPressed: onToggleTheme,
                    icon: Icon(
                      isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon,
                      size: 20,
                    ),
                    style: ReferenceCircleButton.styleOf(context),
                  ),
                  const SizedBox(width: 8),
                  ReferenceCircleButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Cerrar menú',
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                key: ValueKey(isSignedIn),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                children: [
                  ShopSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: onProfile,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ReferenceColors.coral,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isSignedIn ? 'Jack Perez' : 'Bienvenido',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isSignedIn
                                          ? '+51972657028'
                                          : 'Inicia sesión con Google',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSignedIn)
                                TextButton(
                                  onPressed: onProfile,
                                  style: TextButton.styleFrom(
                                    foregroundColor: colors.primary,
                                    backgroundColor: colors.primaryContainer,
                                    shape: const StadiumBorder(),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                    ),
                                  ),
                                  child: const Text('Editar'),
                                ),
                            ],
                          ),
                        ),
                        if (isSignedIn) ...[
                          const Divider(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileStat(
                                  '${shop.orders.length}',
                                  'Pedidos',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ProfileStat(
                                  '${shop.products.where((product) => shop.isFavorite(product.id)).length}',
                                  'Favoritos',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ProfileStat(
                                  '${shop.reviews.length}',
                                  'Reseñas',
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: onSignIn,
                            icon: const Icon(Icons.login_rounded, size: 18),
                            label: const Text('Continuar con Google'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (isSignedIn) ...[
                    _MenuGroup('Mi cuenta', [
                      _DrawerRow(
                        'Mi perfil',
                        CupertinoIcons.person,
                        onTap: onProfile,
                      ),
                      _DrawerRow(
                        'Mis direcciones',
                        Icons.location_on_outlined,
                        onTap: onAddresses,
                      ),
                      _DrawerRow(
                        'Notificaciones',
                        CupertinoIcons.bell,
                        onTap: onNotifications,
                      ),
                    ]),
                    _MenuGroup('Tus compras', [
                      _DrawerRow(
                        'Mis pedidos',
                        Icons.shopping_bag_outlined,
                        onTap: onOrders,
                      ),
                      _DrawerRow(
                        'Mis favoritos',
                        CupertinoIcons.heart,
                        onTap: onFavorites,
                      ),
                      const _DrawerRow(
                        'Devoluciones',
                        Icons.assignment_return_outlined,
                      ),
                      _DrawerRow(
                        'Mis reseñas',
                        Icons.rate_review_outlined,
                        onTap: onReviews,
                      ),
                    ]),
                  ],
                  const _MenuGroup('Ayuda', [
                    _DrawerRow('Ayuda y soporte', CupertinoIcons.chat_bubble_2),
                  ]),
                  _MenuGroup('Información', [
                    const _DrawerRow('Facebook', Icons.facebook),
                    const _DrawerRow('Instagram', CupertinoIcons.camera),
                    const _DrawerRow('WhatsApp', CupertinoIcons.phone_circle),
                    const _DrawerRow(
                      'Libro de reclamaciones',
                      CupertinoIcons.book,
                    ),
                    const _DrawerRow(
                      'Términos y condiciones',
                      CupertinoIcons.doc_text,
                    ),
                    if (isSignedIn)
                      _DrawerRow(
                        'Cerrar sesión',
                        Icons.logout_rounded,
                        onTap: onSignOut,
                      ),
                  ]),
                  Text(
                    'V1.0.0.0.1',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup(this.title, this.rows);
  final String title;
  final List<_DrawerRow> rows;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ShopSurface(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                if (index > 0) const Divider(height: 1, indent: 50),
                rows[index],
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _DrawerRow extends StatelessWidget {
  const _DrawerRow(this.title, this.icon, {this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    horizontalTitleGap: 12,
    minTileHeight: 58,
    minVerticalPadding: 8,
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 19,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    trailing: Icon(
      Icons.chevron_right_rounded,
      size: 19,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
