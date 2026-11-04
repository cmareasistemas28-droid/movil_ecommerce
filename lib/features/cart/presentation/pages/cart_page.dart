import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/extensions/money.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mi carrito')),
      body: SafeArea(
        child: ShopWidth(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: shop.items.isEmpty
                ? [
                    EmptyState(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Tu próximo upgrade te espera',
                      message: 'Agrega tus productos favoritos y los encontrarás aquí.',
                      action: FilledButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        child: const Text('Explorar productos'),
                      ),
                    ),
                  ]
                : [
                    Text(
                      '${shop.cartCount} productos en tu carrito',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    for (final item in shop.items) CartItemTile(item: item),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ShopColors.mint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            color: ShopColors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              shop.shippingCents == 0
                                  ? '¡Tu pedido tiene envío gratis!'
                                  : 'Agrega ${soles(29900 - shop.subtotalCents)} más para obtener envío gratis.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Resumen del pedido',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow(
                            label: 'Subtotal',
                            value: soles(shop.subtotalCents),
                          ),
                          const SizedBox(height: 16),
                          _SummaryRow(
                            label: 'Envío estimado',
                            value: shop.shippingCents == 0
                                ? 'Gratis'
                                : soles(shop.shippingCents),
                          ),
                          const Divider(height: 32),
                          _SummaryRow(
                            label: 'Total',
                            value: soles(shop.totalCents),
                            strong: true,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Precios de demostración. No se realizará ningún cobro.',
                            style: TextStyle(
                              fontSize: 12,
                              color: ShopColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  child: FilledButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        scrollable: true,
                        title: const Text('Estás en una demostración'),
                        content: const Text(
                          'Tu carrito está listo. Para realizar pedidos se necesita conectar el catálogo, las direcciones y una pasarela de pago. No se ha creado un pedido ni realizado un cobro.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Entendido'),
                          ),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Continuar compra · ${soles(shop.totalCents)}',
                        textAlign: TextAlign.center,
                      ),
                    ),
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
            fontSize: strong ? 18 : 14,
            fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: strong ? 22 : 14,
            fontWeight: FontWeight.w700,
            color: strong ? ShopColors.green : ShopColors.ink,
          ),
        ),
      ],
    ),
  );
}
