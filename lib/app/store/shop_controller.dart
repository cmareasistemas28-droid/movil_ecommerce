import 'package:flutter/foundation.dart';

import '../../features/cart/domain/entities/shopping_cart.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/domain/repositories/product_repository.dart';

class ShopController extends ChangeNotifier {
  ShopController(ProductRepository repository)
    : products = List.unmodifiable(repository.getProducts());

  final List<Product> products;
  final ShoppingCart _cart = ShoppingCart();
  final Set<String> _favorites = {};

  List<CartItem> get items => _cart.items;
  int get cartCount => _cart.count;
  int get subtotalCents => _cart.subtotalCents;
  int get shippingCents => _cart.shippingCents;
  int get totalCents => _cart.totalCents;
  int quantityOf(String id) => _cart.quantityOf(id);
  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void add(Product product, [int quantity = 1]) {
    _cart.add(product, quantity);
    notifyListeners();
  }

  void setQuantity(Product product, int quantity) {
    _cart.setQuantity(product, quantity);
    notifyListeners();
  }

  void remove(String id) {
    _cart.remove(id);
    notifyListeners();
  }
}
