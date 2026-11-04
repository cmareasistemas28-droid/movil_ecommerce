import 'package:flutter/widgets.dart';

import 'shop_controller.dart';

class ShopScope extends InheritedNotifier<ShopController> {
  const ShopScope({
    super.key,
    required ShopController controller,
    required super.child,
  }) : super(notifier: controller);

  static ShopController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}
