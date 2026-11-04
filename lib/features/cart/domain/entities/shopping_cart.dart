import '../../../products/domain/entities/product.dart';

class CartItem {
  const CartItem(this.product, this.quantity);
  final Product product;
  final int quantity;
  int get totalCents => product.priceCents * quantity;
}

class ShoppingCart {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => List.unmodifiable(_items.values);
  int quantityOf(String id) => _items[id]?.quantity ?? 0;
  int get count => _items.values.fold(0, (sum, item) => sum + item.quantity);
  int get subtotalCents =>
      _items.values.fold(0, (sum, item) => sum + item.totalCents);
  int get shippingCents => _items.isEmpty || subtotalCents >= 29900 ? 0 : 1500;
  int get totalCents => subtotalCents + shippingCents;

  void add(Product product, [int quantity = 1]) {
    if (quantity <= 0) return;
    setQuantity(product, quantityOf(product.id) + quantity);
  }

  void setQuantity(Product product, int quantity) {
    if (quantity <= 0 || product.stock <= 0) {
      _items.remove(product.id);
    } else {
      _items[product.id] = CartItem(product, quantity.clamp(1, product.stock));
    }
  }

  void remove(String id) => _items.remove(id);
}
