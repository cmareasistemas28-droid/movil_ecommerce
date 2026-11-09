import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../domain/entities/customer_address.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key, this.address});
  final CustomerAddress? address;
  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _form = GlobalKey<FormState>();
  late final _fields = [
    widget.address?.department,
    widget.address?.province,
    widget.address?.district,
    widget.address?.street,
  ].map((text) => TextEditingController(text: text ?? '')).toList();
  bool _saving = false;
  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await accountAction(context, () async {
      final address = await ShopScope.of(context).saveAddress(
        id: widget.address?.id,
        department: _fields[0].text,
        province: _fields[1].text,
        district: _fields[2].text,
        street: _fields[3].text,
      );
      if (mounted) Navigator.pop(context, address.id);
    });
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Nueva dirección' : 'Editar dirección',
        ),
      ),
      body: SafeArea(
        child: ShopWidth(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Dirección de entrega',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Completa los datos para recibir tus pedidos.'),
                const SizedBox(height: 24),
                for (var index = 0; index < 4; index++) ...[
                  TextFormField(
                    key: ValueKey('address-field-$index'),
                    controller: _fields[index],
                    enabled: !_saving,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: index == 3
                        ? TextInputAction.done
                        : TextInputAction.next,
                    maxLength: 200,
                    maxLines: index == 3 ? 3 : 1,
                    decoration: accountInput(
                      context,
                      const [
                        'Departamento',
                        'Provincia',
                        'Distrito',
                        'Dirección',
                      ][index],
                    ).copyWith(counterText: ''),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Completa este campo.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton(
                  key: const Key('save-address'),
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(_saving ? 'Guardando…' : 'Guardar dirección'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
