import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../../shared/widgets/shop_surface.dart';

/// Shared page structure from the supplied profile editing references.
class ProfileEditorLayout extends StatelessWidget {
  const ProfileEditorLayout({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.saveLabel,
    required this.onSave,
  });

  final String title;
  final String description;
  final Widget child;
  final String saveLabel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 0,
      toolbarHeight: 56,
      leading: IconButton(
        tooltip: 'Volver al perfil',
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('Mi perfil'),
    ),
    body: SafeArea(
      top: false,
      child: ShopWidth(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: .76),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ShopSurface(padding: const EdgeInsets.all(14), child: child),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size(48, 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(saveLabel, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

InputDecoration profileEditorInput(
  BuildContext context, {
  required String label,
  String? hint,
  Widget? suffix,
  String? error,
}) => InputDecoration(
  // The visible label sits above the input to match the reference.
  hintText: hint ?? label,
  hintStyle: TextStyle(
    fontSize: 13,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .72),
  ),
  filled: true,
  fillColor: Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF303030)
      : const Color(0xFFF5F5F5),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: ReferenceColors.accent),
  ),
  suffixIcon: suffix,
  errorText: error,
);
