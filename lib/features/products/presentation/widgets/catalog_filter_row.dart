import 'package:flutter/material.dart';

/// A single filter row that scrolls horizontally without wrapping its options.
class CatalogFilterRow extends StatelessWidget {
  const CatalogFilterRow({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
    required this.keyPrefix,
  });

  final List<({String? id, String label})> options;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: ValueKey(options.map((option) => option.id).join('|')),
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var index = 0; index < options.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          ChoiceChip(
            key: ValueKey('$keyPrefix-${options[index].id ?? 'all'}'),
            label: Text(options[index].label, maxLines: 1),
            showCheckmark: false,
            selected: selectedId == options[index].id,
            onSelected: (_) => onSelected(options[index].id),
            shape: const StadiumBorder(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            surfaceTintColor: Colors.transparent,
            elevation: 2,
            pressElevation: 2,
            shadowColor: Colors.black.withValues(alpha: .05),
            selectedShadowColor: Colors.black.withValues(alpha: .05),
            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            side: BorderSide(
              color: selectedId == options[index].id
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            labelStyle: TextStyle(
              fontSize: 12,
              color: selectedId == options[index].id
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: selectedId == options[index].id
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ],
      ],
    ),
  );
}
