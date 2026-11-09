import 'package:flutter/material.dart';

import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../cart/presentation/widgets/quantity_selector.dart';
import 'cart_added_message.dart';

class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    super.key,
    required this.quantity,
    required this.available,
    required this.unitPriceCents,
    required this.onQuantityChanged,
    required this.onAdd,
    required this.messageController,
  });

  final int quantity;
  final int available;
  final int unitPriceCents;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback? onAdd;
  final CartAddedMessageController messageController;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: Border(
      top: BorderSide(color: Theme.of(context).dividerColor, width: .7),
    ),
    child: SafeArea(
      top: false,
      child: ShopWidth(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 16,
                runSpacing: 4,
                children: [
                  Text(
                    'Tu producto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Semantics(
                    liveRegion: true,
                    label: 'Total: ${soles(unitPriceCents * quantity)}',
                    child: ExcludeSemantics(
                      child: Text(
                        soles(unitPriceCents * quantity),
                        key: const Key('detail-total'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (available > 0) ...[
                    QuantitySelector(
                      value: quantity,
                      max: available,
                      filled: true,
                      onChanged: onQuantityChanged,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      key: const Key('detail-add'),
                      onPressed: onAdd,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(48, 44),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        available > 0
                            ? 'Agregar'
                            : 'Stock máximo en tu carrito',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CartAddedMessage(controller: messageController),
            ],
          ),
        ),
      ),
    ),
  );
}
