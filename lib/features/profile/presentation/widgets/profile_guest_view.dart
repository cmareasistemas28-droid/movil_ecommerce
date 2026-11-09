import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class ProfileGuestView extends StatelessWidget {
  const ProfileGuestView({
    super.key,
    required this.onExplore,
    this.onGoogleSignIn,
  });

  final VoidCallback onExplore;
  final VoidCallback? onGoogleSignIn;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: ReferenceColors.tile,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: ReferenceColors.accent,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenido a Cibermax',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Inicia sesión con Google para tener tus compras y favoritos siempre a mano.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onGoogleSignIn,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_rounded, size: 22),
                          SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Continuar con Google',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onExplore,
                    child: const Text('Seguir explorando'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _AccountBenefit(
              icon: Icons.shopping_bag_outlined,
              title: 'Tus compras en un solo lugar',
              description: 'Consulta tus pedidos y devoluciones.',
            ),
            const SizedBox(height: 16),
            const _AccountBenefit(
              icon: Icons.favorite_border_rounded,
              title: 'Guarda lo que te gusta',
              description: 'Encuentra fácilmente tus productos favoritos.',
            ),
            const SizedBox(height: 16),
            const _AccountBenefit(
              icon: Icons.location_on_outlined,
              title: 'Todo listo para tu próxima compra',
              description: 'Ten tus direcciones a mano.',
            ),
          ],
        ),
      ),
    ),
  );
}

class _AccountBenefit extends StatelessWidget {
  const _AccountBenefit({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: ReferenceColors.accent, size: 24),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    ],
  );
}
