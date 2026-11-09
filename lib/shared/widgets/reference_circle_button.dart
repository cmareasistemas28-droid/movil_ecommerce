import 'package:flutter/material.dart';

class ReferenceCircleButton extends StatelessWidget {
  const ReferenceCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  static ButtonStyle styleOf(BuildContext context, {double size = 44}) =>
      IconButton.styleFrom(
        fixedSize: Size.square(size),
        iconSize: 20,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: .06),
        side: BorderSide.none,
        shape: const CircleBorder(),
      );

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(
      icon,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      size: 20,
    ),
    style: styleOf(context),
  );
}
