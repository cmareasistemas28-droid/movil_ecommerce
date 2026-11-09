import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/router/instant_page_route.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../addresses/presentation/widgets/checkout_addresses.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, this.onExplore, this.onOrderPlaced});
  final VoidCallback? onExplore;
  final VoidCallback? onOrderPlaced;

  Future<void> _buy(BuildContext context) async {
    final shop = ShopScope.of(context);
    final saved = await accountAction(context, () async {
      await shop.placeOrder();
    });
    if (!saved || !context.mounted) return;
    if (onOrderPlaced != null) {
      onOrderPlaced!();
    } else {
      Navigator.of(context).pushReplacement(
        InstantPageRoute<void>(builder: (_) => const OrdersPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mi carrito'), centerTitle: true),
      body: SafeArea(
        child: ShopWidth(
          child: AbsorbPointer(
            absorbing: shop.checkoutInProgress,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: shop.items.isEmpty
                  ? [
                      EmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Tu próximo upgrade te espera',
                        message: 'Agrega tus productos favoritos y los encontrarás aquí.',
                        action: FilledButton(
                          onPressed:
                              onExplore ??
                              () => Navigator.pushReplacementNamed(
                                context,
                                '/products',
                              ),
                          child: const Text('Explorar productos'),
                        ),
                      ),
                    ]
                  : [
                      const CheckoutAddresses(),
                      const SizedBox(height: 24),
                      Text(
                        '${shop.cartCount} productos en tu carrito',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      for (final item in shop.items)
                        CartItemTile(
                          key: ValueKey('cart-item-${item.product.id}'),
                          item: item,
                        ),
                      const SizedBox(height: 24),
                      Text(
                        'Resumen del pedido',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      AccountCard(
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Subtotal',
                              value: soles(shop.subtotalCents),
                            ),
                            const SizedBox(height: 16),
                            _SummaryRow(
                              label: 'Costo de envío',
                              value: soles(shop.shippingCents),
                            ),
                            const Divider(height: 32),
                            _SummaryRow(
                              label: 'Total',
                              value: soles(shop.totalCents),
                              strong: true,
                            ),
                          ],
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: shop.items.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: ShopWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (shop.selectedAddress == null) ...[
                        const Text(
                          'Selecciona una dirección para continuar.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                      ],
                      FilledButton(
                        key: const Key('place-order'),
                        onPressed:
                            shop.selectedAddress == null ||
                                shop.checkoutInProgress
                            ? null
                            : () => _buy(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            shop.checkoutInProgress
                                ? 'Creando pedido…'
                                : 'Realizar compra · ${soles(shop.totalCents)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
  });
  final String label;
  final String value;
  final bool strong;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 24,
      runSpacing: 4,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: strong ? 15 : 13,
            fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: strong ? 17 : 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
