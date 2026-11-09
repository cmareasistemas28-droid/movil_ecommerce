import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/router/instant_page_route.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../widgets/profile_guest_view.dart';
import 'profile_birth_date_edit_page.dart';
import 'profile_document_edit_page.dart';
import 'profile_text_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.onBack,
    this.isSignedIn = false,
    this.onGoogleSignIn,
    this.onSignOut,
  });
  final VoidCallback onBack;
  final bool isSignedIn;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onSignOut;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _values = <String, String>{
    'Nombres': 'Jack',
    'Apellidos': 'Perez',
    'Número de documento': '',
    'Número de celular': '+51972657028',
    'Segundo número de celular': '',
  };
  String? _documentType;
  DateTime? _birthDate;
  bool _passwordPreview = false;

  String get _fullName =>
      '${_values['Nombres']} ${_values['Apellidos']}'.trim();
  String get _initials => [_values['Nombres']!, _values['Apellidos']!]
      .where((part) => part.trim().isNotEmpty)
      .map((part) => part.trim().characters.first)
      .join()
      .toUpperCase();

  String get _age {
    final birth = _birthDate;
    if (birth == null) return 'Sin especificar';
    final today = DateTime.now();
    var years = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      years--;
    }
    return '$years años';
  }

  Future<T?> _openEditor<T>(Widget page) {
    final theme = Theme.of(context);
    return Navigator.of(context).push<T>(
      InstantPageRoute<T>(
        builder: (_) => Theme(data: theme, child: page),
      ),
    );
  }

  Future<void> _edit(
    String title, {
    TextInputType keyboardType = TextInputType.text,
    bool password = false,
  }) async {
    final value = await _openEditor<String>(
      ProfileTextEditPage(
        title: title,
        initialValue: password ? '' : _values[title] ?? '',
        keyboardType: keyboardType,
        password: password,
      ),
    );
    if (!mounted || value == null) return;
    setState(() {
      if (password) {
        _passwordPreview = value.isNotEmpty;
      } else {
        _values[title] = value.trim();
      }
    });
  }

  Future<void> _editDocument() async {
    final document = await _openEditor<ProfileDocumentValue>(
      ProfileDocumentEditPage(
        initialType: _documentType,
        initialNumber: _values['Número de documento']!,
      ),
    );
    if (!mounted || document == null) return;
    setState(() {
      _documentType = document.type;
      _values['Número de documento'] = document.number;
    });
  }

  Future<void> _chooseBirthDate() async {
    final date = await _openEditor<DateTime>(
      ProfileBirthDateEditPage(initialDate: _birthDate),
    );
    if (mounted && date != null) setState(() => _birthDate = date);
  }

  Widget _editableField(
    String title,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) => _ProfileField(
    icon: icon,
    title: title,
    value: _values[title]!.isEmpty ? 'Sin especificar' : _values[title]!,
    onTap: () => _edit(title, keyboardType: keyboardType),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 0,
      toolbarHeight: 56,
      leading: IconButton(
        tooltip: 'Volver al inicio',
        onPressed: widget.onBack,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: Text(widget.isSignedIn ? 'Mi perfil' : 'Iniciar sesión'),
    ),
    body: SafeArea(
      top: false,
      child: ShopWidth(
        child: ListView(
          key: ValueKey(widget.isSignedIn),
          padding: widget.isSignedIn
              ? EdgeInsets.zero
              : const EdgeInsets.all(20),
          children: [
            if (!widget.isSignedIn)
              ProfileGuestView(
                onExplore: widget.onBack,
                onGoogleSignIn: widget.onGoogleSignIn,
              )
            else ...[
              const SizedBox(height: 22),
              Center(
                child: Semantics(
                  image: true,
                  label: 'Foto de perfil de $_fullName, iniciales $_initials',
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ReferenceColors.avatar,
                          border: Border.all(
                            color: const Color(0xFFC7C4D2),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: ExcludeSemantics(
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -1,
                        bottom: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 15,
                            color: Color(0xFFF1F0F3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _editableField(
                'Nombres',
                CupertinoIcons.person,
                keyboardType: TextInputType.name,
              ),
              const _FieldDivider(),
              _editableField(
                'Apellidos',
                CupertinoIcons.person_2,
                keyboardType: TextInputType.name,
              ),
              const _FieldDivider(),
              _ProfileField(
                icon: CupertinoIcons.doc_text,
                title: 'Tipo de documento',
                value: _documentType ?? 'Seleccionar',
                onTap: _editDocument,
              ),
              const _FieldDivider(),
              _ProfileField(
                icon: CupertinoIcons.number,
                title: 'Número de documento',
                value: _values['Número de documento']!.isEmpty
                    ? 'Sin especificar'
                    : _values['Número de documento']!,
                onTap: _editDocument,
              ),
              const _FieldDivider(),
              _ProfileField(
                icon: CupertinoIcons.calendar,
                title: 'Fecha de nacimiento',
                value: _birthDate == null
                    ? 'Sin especificar'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_birthDate!),
                onTap: _chooseBirthDate,
              ),
              const _FieldDivider(),
              _ProfileField(
                icon: CupertinoIcons.gift,
                title: 'Edad',
                value: _age,
                onTap: _chooseBirthDate,
              ),
              const _FieldDivider(),
              _editableField(
                'Número de celular',
                CupertinoIcons.device_phone_portrait,
                keyboardType: TextInputType.phone,
              ),
              const _FieldDivider(),
              _editableField(
                'Segundo número de celular',
                CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const _FieldDivider(),
              const _ProfileField(
                icon: CupertinoIcons.envelope,
                title: 'Correo electrónico',
                value: 'jackdev2399@gmail.com',
                locked: true,
              ),
              const _FieldDivider(),
              _ProfileField(
                icon: CupertinoIcons.lock,
                title: 'Contraseña',
                value: _passwordPreview ? '••••••••' : 'Sin especificar',
                onTap: () => _edit('Contraseña', password: true),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: OutlinedButton(
                  onPressed: widget.onSignOut,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    minimumSize: const Size(48, 52),
                    side: const BorderSide(color: Color(0xFFC9C9CC)),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Cerrar sesión'),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _FieldDivider extends StatelessWidget {
  const _FieldDivider();
  @override
  Widget build(BuildContext context) => const Divider(height: 1, indent: 64);
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.locked = false,
  });
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) => Semantics(
    key: ValueKey('profile-field-$title'),
    readOnly: locked,
    child: InkWell(
      onTap: locked ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: .76),
                    ),
                  ),
                ],
              ),
            ),
            if (locked || onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                locked
                    ? Icons.lock_outline_rounded
                    : Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
