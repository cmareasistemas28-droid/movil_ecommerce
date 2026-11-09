import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/features/products/data/repositories/demo_product_repository.dart';

void main() {
  test(
    'printer examples preserve source prices, photos and distinct identities',
    () {
      final products = const DemoProductRepository().getProducts();
      final printers = products
          .where((product) => product.imageAssets.isNotEmpty)
          .toList();
      expect(products.length, 80);
      expect(printers.length, 80);
      expect(products.any((product) => product.oldPriceCents != null), isTrue);
      expect(products.any((product) => product.oldPriceCents == null), isTrue);
      expect(
        products.every(
          (product) =>
              product.oldPriceCents == null ||
              product.oldPriceCents! > product.priceCents,
        ),
        isTrue,
      );
      expect(
        products.map((product) => product.id).toSet().length,
        products.length,
      );
      expect(
        printers
            .where((product) => product.subcategoryId == 'multifuncionales')
            .length,
        40,
      );
      expect(
        printers
            .where((product) => product.subcategoryId == 'impresoras-wifi')
            .length,
        40,
      );
      expect(
        printers.every((product) => product.imageAssets.length == 3),
        isTrue,
      );
      for (final source in const {
        'hp-smart-tank-315': 65000,
        'epson-ecotank-l3110': 74000,
        'epson-ecotank-l3160': 95000,
        'hp-smart-tank-515': 85000,
      }.entries) {
        final base = printers.singleWhere(
          (product) => product.id == source.key,
        );
        expect(base.priceCents, source.value);
        final copies = printers.where(
          (product) => product.id.startsWith('${source.key}-demo-'),
        );
        expect(copies.length, 19);
        for (final copy in copies) {
          expect(copy.priceCents, source.value);
          expect(copy.imageAssets, base.imageAssets);
          expect(copy.name, contains('Demo'));
          expect(copy.subcategoryId, base.subcategoryId);
        }
      }
    },
  );
}
