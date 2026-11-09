import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.min = 1,
    this.filled = false,
    this.compact = false,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final bool filled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(
          tooltip: 'Disminuir cantidad',
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: Icons.remove,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact
                ? 0
                : filled
                ? 4
                : 12,
          ),
          child: Semantics(
            liveRegion: true,
            label: 'Cantidad: $value',
            child: ExcludeSemantics(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: compact ? 24 : 0),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: compact
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )
                      : filled
                      ? Theme.of(context).textTheme.titleMedium
                      : null,
                ),
              ),
            ),
          ),
        ),
        _button(
          tooltip: 'Aumentar cantidad',
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: Icons.add,
        ),
      ],
    );
    if (compact) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: controls,
      );
    }
    if (!filled) return controls;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : ReferenceColors.tile,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: controls,
      ),
    );
  }

  Widget _button({
    required String tooltip,
    required VoidCallback? onPressed,
    required IconData icon,
  }) => compact
      ? IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(
            fixedSize: const Size(44, 44),
            padding: EdgeInsets.zero,
          ),
        )
      : filled
      ? IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, size: 22),
          style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
        )
      : IconButton.outlined(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
        );
}
