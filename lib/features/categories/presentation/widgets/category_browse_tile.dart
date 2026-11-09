import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

String catalogProductCount(int count) =>
    count == 1 ? '1 producto' : '$count productos';

IconData catalogIconFor(String id) => switch (id) {
  'impresoras' || 'multifuncionales' => Icons.print_outlined,
  'impresoras-wifi' => Icons.wifi_outlined,
  'perifericos' || 'teclados' => Icons.keyboard_outlined,
  'mouse' => Icons.mouse_outlined,
  'audio' || 'audifonos' => Icons.headphones_outlined,
  'parlantes' => Icons.speaker_group_outlined,
  'componentes' || 'tarjetas-graficas' => Icons.memory_outlined,
  'almacenamiento' => Icons.storage_outlined,
  'cables' || 'cables-usb' => Icons.cable_outlined,
  'cables-hdmi' => Icons.settings_input_hdmi_outlined,
  _ => Icons.grid_view_outlined,
};

class CategoryBrowseTile extends StatelessWidget {
  const CategoryBrowseTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: highlight
          ? ReferenceColors.accent.withValues(alpha: .07)
          : colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: .45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ReferenceColors.accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 26, color: ReferenceColors.accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
