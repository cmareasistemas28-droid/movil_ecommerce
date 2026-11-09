import 'package:flutter/material.dart';

import '../../app/router/instant_page_route.dart';
import 'shop_layout.dart';
import 'shop_surface.dart';
import 'reference_circle_button.dart';

Future<T?> openShopPage<T>(BuildContext context, Widget page) {
  final theme = Theme.of(context);
  return Navigator.of(context).push<T>(
    InstantPageRoute<T>(
      builder: (_) => Theme(data: theme, child: page),
    ),
  );
}

Future<bool> accountAction(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } catch (error) {
    if (context.mounted) {
      final message = error is StateError
          ? error.message
          : error is ArgumentError
          ? error.message.toString()
          : 'No se pudieron guardar los cambios. Inténtalo de nuevo.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    return false;
  }
}

String accountDate(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
String accountDateTime(BuildContext context, DateTime date) {
  final local = date.toLocal();
  return '${accountDate(context, local)} · ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
}

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
    required this.title,
    required this.children,
    this.actions,
  });
  final String title;
  final List<Widget> children;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      actions: actions,
      centerTitle: title == 'Notificaciones' || title == 'Detalle del pedido',
      leading: ModalRoute.of(context)?.canPop == true
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: BackButton(style: ReferenceCircleButton.styleOf(context)),
            )
          : null,
    ),
    body: SafeArea(
      child: ShopWidth(
        child: ListView(
          key: PageStorageKey('account-$title'),
          padding: const EdgeInsets.all(20),
          children: children,
        ),
      ),
    ),
  );
}

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: ShopSurface(child: child),
  );
}

InputDecoration accountInput(BuildContext context, String label) =>
    InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
