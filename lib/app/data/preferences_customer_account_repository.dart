import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../store/customer_account.dart';

class PreferencesCustomerAccountRepository
    implements CustomerAccountRepository {
  PreferencesCustomerAccountRepository(this.preferences);
  final SharedPreferences preferences;
  static const _key = 'cibermax.customer-account.v1';
  @override
  CustomerAccount load() {
    final source = preferences.getString(_key);
    if (source == null) return CustomerAccount();
    return CustomerAccount.fromJson(
      Map<String, dynamic>.from(jsonDecode(source) as Map),
    );
  }

  @override
  Future<void> save(CustomerAccount account) async {
    if (!await preferences.setString(_key, jsonEncode(account.toJson()))) {
      throw StateError(
        'No se pudieron guardar los cambios. Inténtalo de nuevo.',
      );
    }
  }
}
