import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../orders/presentation/pages/order_detail_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final colors = Theme.of(context).colorScheme;
    return AccountPage(
      title: 'Notificaciones',
      actions: [
        if (shop.unreadNotificationCount > 0)
          IconButton(
            tooltip: 'Marcar todas como leídas',
            onPressed: () =>
                accountAction(context, shop.markAllNotificationsRead),
            icon: const Icon(Icons.done_all, size: 20),
          ),
      ],
      children: [
        if (shop.notifications.isEmpty)
          const EmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No tienes notificaciones',
            message: 'Aquí verás la confirmación y los cambios de estado de tus pedidos.',
          ),
        for (final notice in shop.notifications)
          AccountCard(
            child: InkWell(
              onTap: () async {
                final saved = await accountAction(
                  context,
                  () => shop.markNotificationRead(notice.id),
                );
                if (saved && context.mounted) {
                  openShopPage<void>(
                    context,
                    OrderDetailPage(orderId: notice.orderId),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notice.isRead
                          ? colors.surfaceContainerLow
                          : colors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notice.orderId.isEmpty
                          ? Icons.notifications_outlined
                          : notice.id.endsWith('onTheWay')
                          ? Icons.local_shipping_outlined
                          : notice.id.endsWith('delivered')
                          ? Icons.check_circle_outline_rounded
                          : Icons.notifications_active_outlined,
                      size: 20,
                      color: notice.isRead
                          ? colors.onSurfaceVariant
                          : colors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notice.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              accountDate(context, notice.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notice.message,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
