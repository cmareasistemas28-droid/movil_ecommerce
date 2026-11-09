import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../pages/address_form_page.dart';

class CheckoutAddresses extends StatelessWidget {
  const CheckoutAddresses({super.key});
  Future<void> _add(BuildContext context) async {
    final id = await openShopPage<String>(context, const AddressFormPage());
    if (id != null && context.mounted) {
      await accountAction(
        context,
        () => ShopScope.of(context).selectAddress(id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Dirección de entrega',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (shop.addresses.isEmpty)
          AccountCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Agrega una dirección para realizar tu compra.'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _add(context),
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text('Agregar dirección'),
                ),
              ],
            ),
          )
        else ...[
          const Text('Selecciona dónde quieres recibir tu pedido.'),
          const SizedBox(height: 12),
          RadioGroup<String>(
            groupValue: shop.selectedAddress?.id,
            onChanged: (id) {
              if (id != null) {
                accountAction(context, () => shop.selectAddress(id));
              }
            },
            child: Column(
              children: [
                for (final address in shop.addresses)
                  AccountCard(
                    child: RadioListTile<String>(
                      key: ValueKey('checkout-address-${address.id}'),
                      value: address.id,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        address.street,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(address.region),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar dirección'),
            ),
          ),
        ],
      ],
    );
  }
}
