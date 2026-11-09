import 'package:flutter_test/flutter_test.dart';
import 'package:cibermax_movil/features/cart/domain/entities/shopping_cart.dart';
import 'package:cibermax_movil/features/products/domain/entities/product.dart';

void main() {
  const products = [
    Product(
      id: 'cart-fixture-1',
      name: 'Ejemplo de prueba 1',
      subcategoryId: 'test',
      priceCents: 12900,
      rating: 5,
      description: '',
      specifications: {},
      art: '',
    ),
    Product(
      id: 'cart-fixture-2',
      name: 'Ejemplo de prueba 2',
      subcategoryId: 'test',
      priceCents: 25900,
      rating: 5,
      description: '',
      specifications: {},
      art: '',
    ),
  ];

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
