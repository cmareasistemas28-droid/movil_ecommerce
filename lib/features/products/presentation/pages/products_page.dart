import 'package:flutter/material.dart';

import 'catalog_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) => const CatalogPage(embedded: true);
}
