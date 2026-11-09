import 'package:flutter/material.dart';

/// Opens and closes a page without a slide, fade or scale transition.
class InstantPageRoute<T> extends PageRouteBuilder<T> {
  InstantPageRoute({required WidgetBuilder builder, super.settings})
    : super(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, _) => builder(context),
        transitionsBuilder: (_, _, _, child) => child,
      );
}
