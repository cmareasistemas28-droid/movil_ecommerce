import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_theme.dart';
import '../widgets/profile_editor_layout.dart';

class ProfileDocumentValue {
  const ProfileDocumentValue(this.type, this.number);
  final String type;
  final String number;
}

class ProfileDocumentEditPage extends StatefulWidget {
  const ProfileDocumentEditPage({
    super.key,
    this.initialType,
    required this.initialNumber,
  });
  final String? initialType;
  final String initialNumber;

  @override
  State<ProfileDocumentEditPage> createState() =>
      _ProfileDocumentEditPageState();
}

class _ProfileDocumentEditPageState extends State<ProfileDocumentEditPage> {
  late String _type = widget.initialType ?? 'DNI';
  late final _number = TextEditingController(text: widget.initialNumber);
  final _formKey = GlobalKey<FormState>();

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, ProfileDocumentValue(_type, _number.text.trim()));
    }
  }

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProfileEditorLayout(
    title: 'Documento de identidad',
    description: 'Selecciona el tipo de documento y actualiza el número asociado a tu cuenta.',
    saveLabel: 'Guardar documento',
    onSave: _save,
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tipo de documento',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final type in ['DNI', 'CIP']) ...[
                if (type != 'DNI') const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    selected: _type == type,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _type = type),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(48, 44),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        foregroundColor: _type == type
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        backgroundColor: _type == type
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        side: BorderSide(
                          color: _type == type
                              ? Theme.of(context).colorScheme.primary
                                    .withValues(alpha: .35)
                              : Theme.of(context).dividerColor
                                    .withValues(alpha: .2),
                        ),
                        shape: const StadiumBorder(),
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: _type == type
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      child: Text(type),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          const Text('Número', style: TextStyle(fontSize: 13, height: 1.2)),
          const SizedBox(height: 8),
          Semantics(
            label: 'Número de documento',
            child: TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              cursorColor: ReferenceColors.accent,
              style: const TextStyle(fontSize: 14, height: 1.2),
              onFieldSubmitted: (_) => _save(),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ingresa tu número de documento.'
                  : null,
              decoration: profileEditorInput(
                context,
                label: 'Número',
                hint: 'Ingresa tu número',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
