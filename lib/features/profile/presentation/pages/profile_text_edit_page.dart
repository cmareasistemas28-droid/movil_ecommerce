import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../widgets/profile_editor_layout.dart';

class ProfileTextEditPage extends StatefulWidget {
  const ProfileTextEditPage({
    super.key,
    required this.title,
    required this.initialValue,
    required this.keyboardType,
    this.password = false,
  });
  final String title;
  final String initialValue;
  final TextInputType keyboardType;
  final bool password;

  @override
  State<ProfileTextEditPage> createState() => _ProfileTextEditPageState();
}

class _ProfileTextEditPageState extends State<ProfileTextEditPage> {
  late final _controller = TextEditingController(text: widget.initialValue);
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  String get _description => switch (widget.title) {
    'Nombres' => 'Actualiza los nombres asociados a tu cuenta.',
    'Apellidos' => 'Actualiza los apellidos asociados a tu cuenta.',
    'Número de celular' =>
      'Actualiza el número de celular asociado a tu cuenta.',
    'Segundo número de celular' =>
      'Agrega o actualiza tu segundo número de celular.',
    _ => 'Actualiza la contraseña de tu cuenta.',
  };

  String get _saveLabel => switch (widget.title) {
    'Nombres' => 'Guardar nombres',
    'Apellidos' => 'Guardar apellidos',
    'Número de celular' || 'Segundo número de celular' => 'Guardar celular',
    _ => 'Guardar contraseña',
  };

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProfileEditorLayout(
    title: widget.title,
    description: _description,
    saveLabel: _saveLabel,
    onSave: _save,
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 13, height: 1.2)),
          const SizedBox(height: 8),
          Semantics(
            label: widget.title,
            child: TextFormField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.password && _obscure,
              enableSuggestions: !widget.password,
              autocorrect: !widget.password,
              textCapitalization: widget.keyboardType == TextInputType.name
                  ? TextCapitalization.words
                  : TextCapitalization.none,
              textInputAction: TextInputAction.done,
              cursorColor: ReferenceColors.accent,
              style: const TextStyle(fontSize: 14, height: 1.2),
              onFieldSubmitted: (_) => _save(),
              validator: (value) =>
                  widget.title != 'Segundo número de celular' &&
                      (value == null || value.trim().isEmpty)
                  ? 'Completa este campo.'
                  : null,
              decoration: profileEditorInput(
                context,
                label: widget.title,
                hint: widget.password
                    ? 'Ingresa tu contraseña'
                    : 'Ingresa ${widget.title.toLowerCase()}',
                suffix: widget.password
                    ? IconButton(
                        tooltip: _obscure
                            ? 'Mostrar contraseña'
                            : 'Ocultar contraseña',
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
