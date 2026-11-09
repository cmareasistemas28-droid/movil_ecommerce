import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../domain/entities/customer_order.dart';
import '../widgets/order_status_badge.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    final order = ShopScope.of(context).orderById(orderId);
    final theme = Theme.of(context);
    final eventTimes = {
      for (final event in order.events) event.status: event.at,
    };
    return AccountPage(
      title: 'Detalle del pedido',
      children: [
        Text(order.id, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          accountDateTime(context, order.createdAt),
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        OrderStatusBadge(status: order.status),
        const SizedBox(height: 24),
        Text('Estado del pedido', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        AccountCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final status in OrderStatus.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        status.index <= order.status.index
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        color: status.index <= order.status.index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.label,
                              style: theme.textTheme.bodyLarge,
                            ),
                            if (eventTimes[status] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                accountDateTime(context, eventTimes[status]!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Dirección de entrega', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        AccountCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(order.address.street, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(order.address.region),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Productos', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final line in order.lines)
          AccountCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  line.imageAsset,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                  semanticLabel: line.name,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(Icons.inventory_2_outlined),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(line.name, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text(
                        '${line.quantity} × ${soles(line.unitPriceCents)}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        soles(line.totalCents),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Text('Resumen del pedido', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        AccountCard(
          child: Column(
            children: [
              _Total('Subtotal', order.subtotalCents),
              const SizedBox(height: 12),
              _Total('Costo de envío', order.shippingCents),
              const Divider(height: 32),
              _Total('Total', order.totalCents, strong: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _Total extends StatelessWidget {
  const _Total(this.label, this.cents, {this.strong = false});
  final String label;
  final int cents;
  final bool strong;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 20,
      runSpacing: 8,
      children: [
        Text(label),
        Text(
          soles(cents),
          style: TextStyle(
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
