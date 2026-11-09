import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../domain/entities/customer_address.dart';
import 'address_form_page.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});
  Future<void> _delete(BuildContext context, CustomerAddress address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: Text(
          '¿Eliminar ${address.street}? Los pedidos realizados conservarán su dirección de entrega.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await accountAction(
        context,
        () => ShopScope.of(context).deleteAddress(address.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return AccountPage(
      title: 'Mis direcciones',
      children: [
        FilledButton.icon(
          onPressed: () =>
              openShopPage<String>(context, const AddressFormPage()),
          icon: const Icon(Icons.add_location_alt_outlined),
          label: const Text('Agregar dirección'),
        ),
        const SizedBox(height: 24),
        if (shop.addresses.isEmpty)
          const EmptyState(
            icon: Icons.location_on_outlined,
            title: 'Guarda tu primera dirección',
            message: 'Agrega el departamento, provincia, distrito y dirección de entrega.',
          ),
        for (final address in shop.addresses)
          AccountCard(
            key: ValueKey('saved-address-${address.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  address.street,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  address.region,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: () => openShopPage<String>(
                        context,
                        AddressFormPage(address: address),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text('Editar'),
                    ),
                    IconButton(
                      tooltip: 'Eliminar dirección ${address.street}',
                      onPressed: () => _delete(context, address),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
