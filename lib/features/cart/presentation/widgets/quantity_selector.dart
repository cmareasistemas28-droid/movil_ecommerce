import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.min = 1,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton.outlined(
        tooltip: 'Disminuir cantidad',
        onPressed: value > min ? () => onChanged(value - 1) : null,
        icon: const Icon(Icons.remove, size: 18),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Semantics(
          liveRegion: true,
          label: 'Cantidad: $value',
          child: ExcludeSemantics(child: Text('$value')),
        ),
      ),
      IconButton.outlined(
        tooltip: 'Aumentar cantidad',
        onPressed: value < max ? () => onChanged(value + 1) : null,
        icon: const Icon(Icons.add, size: 18),
      ),
    ],
  );
}
