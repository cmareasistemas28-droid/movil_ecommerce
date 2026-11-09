import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../widgets/order_status_badge.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final theme = Theme.of(context);
    return AccountPage(
      title: 'Mis pedidos',
      children: [
        if (shop.orders.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Todavía no tienes pedidos',
            message: 'Tus compras aparecerán aquí cuando confirmes un pedido.',
          ),
        for (final order in shop.orders)
          AccountCard(
            key: ValueKey('order-${order.id}'),
            child: InkWell(
              onTap: () => openShopPage<void>(
                context,
                OrderDetailPage(orderId: order.id),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (order.lines.isNotEmpty) ...[
                        Image.asset(
                          order.lines.first.imageAsset,
                          width: 72,
                          height: 76,
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                          errorBuilder: (_, _, _) => const SizedBox(
                            width: 72,
                            height: 76,
                            child: Icon(Icons.inventory_2_outlined),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              order.lines
                                  .map(
                                    (line) => '${line.quantity} × ${line.name}',
                                  )
                                  .join('\n'),
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              order.id,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              accountDate(context, order.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      OrderStatusBadge(status: order.status),
                      Text(
                        soles(order.totalCents),
                        style: theme.textTheme.titleMedium,
                      ),
                      FilledButton(
                        onPressed: () => openShopPage<void>(
                          context,
                          OrderDetailPage(orderId: order.id),
                        ),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(48, 36),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Ver detalle'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
