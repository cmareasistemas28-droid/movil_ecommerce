import 'package:flutter/material.dart';

/// Shared white, softly elevated surface from the supplied visual references.
class ShopSurface extends StatelessWidget {
  const ShopSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  static List<BoxShadow> shadows(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withValues(
        alpha: Theme.of(context).brightness == Brightness.dark ? .20 : .065,
      ),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadows(context),
    ),
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: padding, child: child),
    ),
  );
}
