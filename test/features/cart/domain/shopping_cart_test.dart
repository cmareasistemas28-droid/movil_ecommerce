import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/features/cart/domain/entities/shopping_cart.dart';
import 'package:cibermax_movil/features/products/data/repositories/demo_product_repository.dart';

void main() {
  final products = const DemoProductRepository().getProducts();

  test('quantities merge, stay within stock, and use integer totals', () {
    final cart = ShoppingCart();
    cart.add(products.first, 2);
    cart.add(products.first);
    expect(cart.items.length, 1);
    expect(cart.count, 3);
    expect(cart.subtotalCents, 38700);
    expect(cart.shippingCents, 0);
    cart.setQuantity(products.first, 1000);
    expect(cart.count, products.first.stock);
    cart.setQuantity(products.first, 0);
    expect(cart.items, isEmpty);
    expect(cart.totalCents, 0);
  });

  test('shipping is charged below threshold and removed at threshold', () {
    final cart = ShoppingCart();
    cart.add(products.first);
    expect(cart.shippingCents, 1500);
    expect(cart.totalCents, 14400);
    cart.add(products[1]);
    expect(cart.shippingCents, 0);
    cart.remove(products[1].id);
    expect(cart.shippingCents, 1500);
    cart.remove(products.first.id);
    expect(cart.shippingCents, 0);
  });
}
