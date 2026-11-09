import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/products/data/repositories/demo_product_repository.dart';
import '../features/categories/data/repositories/demo_category_repository.dart';
import 'router/app_router.dart';
import 'store/shop_controller.dart';
import 'store/shop_scope.dart';
import 'store/customer_account.dart';
import 'theme/app_theme.dart';

class CibermaxApp extends StatefulWidget {
  const CibermaxApp({super.key, this.accountRepository});
  final CustomerAccountRepository? accountRepository;

  @override
  State<CibermaxApp> createState() => _CibermaxAppState();
}

class _CibermaxAppState extends State<CibermaxApp> {
  late final _shop = ShopController(
    const DemoProductRepository(),
    categoriesRepository: const DemoCategoryRepository(),
    accountRepository: widget.accountRepository,
  );

  @override
  void dispose() {
    _shop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShopScope(
    controller: _shop,
    child: MaterialApp(
      title: 'Cibermax',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.reference(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
        physics: const ClampingScrollPhysics(),
      ),
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
}
