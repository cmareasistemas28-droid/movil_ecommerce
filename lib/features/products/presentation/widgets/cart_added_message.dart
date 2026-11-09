import 'dart:async';

import 'package:flutter/material.dart';

class CartAddedMessageController extends ChangeNotifier {
  Timer? _timer;
  bool _visible = false;
  bool get visible => _visible;

  void show() {
    _timer?.cancel();
    _visible = true;
    notifyListeners();
    _timer = Timer(const Duration(seconds: 2), () {
      _visible = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Reserves one text line so confirmation never overlaps content or moves controls.
class CartAddedMessage extends StatelessWidget {
  const CartAddedMessage({super.key, required this.controller});

  final CartAddedMessageController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Visibility(
      visible: controller.visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Semantics(
        liveRegion: true,
        child: Text(
          'Se agregó al carrito',
          key: const Key('cart-added-message'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
          ),
        ),
      ),
    ),
  );
}
