import 'package:flutter/foundation.dart';

import 'dart:math' as math;

import '../../features/cart/domain/entities/shopping_cart.dart';
import '../../features/categories/domain/entities/product_category.dart';
import '../../features/categories/domain/entities/product_subcategory.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/addresses/domain/entities/customer_address.dart';
import '../../features/orders/domain/entities/customer_order.dart';
import '../../features/notifications/domain/entities/customer_notification.dart';
import '../../features/reviews/domain/entities/customer_review.dart';
import 'customer_account.dart';

class ShopController extends ChangeNotifier {
  ShopController(
    ProductRepository repository, {
    required CategoryRepository categoriesRepository,
    CustomerAccountRepository? accountRepository,
  }) : _accountRepository =
           accountRepository ?? MemoryCustomerAccountRepository(),
       products = List.unmodifiable(repository.getProducts()),
       categories = List.unmodifiable(categoriesRepository.getCategories()),
       subcategories = List.unmodifiable(
         categoriesRepository.getSubcategories(),
       ) {
    _account = _accountRepository.load();
    _categoriesById = {
      for (final category in categories) category.id: category,
    };
    _subcategoriesById = {
      for (final subcategory in subcategories) subcategory.id: subcategory,
    };
    if (_categoriesById.length != categories.length ||
        _subcategoriesById.length != subcategories.length) {
      throw ArgumentError(
        'Los identificadores de categorías y subcategorías deben ser únicos.',
      );
    }
    for (final subcategory in subcategories) {
      if (!_categoriesById.containsKey(subcategory.categoryId)) {
        throw ArgumentError(
          'La subcategoría ${subcategory.id} no tiene una categoría válida.',
        );
      }
    }
    for (final product in products) {
      if (!_subcategoriesById.containsKey(product.subcategoryId)) {
        throw ArgumentError(
          'El producto ${product.id} no tiene una subcategoría válida.',
        );
      }
    }
  }

  final List<Product> products;
  final List<ProductCategory> categories;
  final List<ProductSubcategory> subcategories;
  late final Map<String, ProductCategory> _categoriesById;
  late final Map<String, ProductSubcategory> _subcategoriesById;
  final ShoppingCart _cart = ShoppingCart();
  final Set<String> _favorites = {};
  final CustomerAccountRepository _accountRepository;
  late CustomerAccount _account;
  Future<void> _pending = Future.value();
  bool _checkoutPending = false;
  bool _disposed = false;
  bool get checkoutInProgress => _checkoutPending;
  List<CustomerAddress> get addresses => _account.addresses;
  List<CustomerOrder> get orders => _account.orders;
  List<CustomerNotification> get notifications => _account.notifications;
  List<CustomerReview> get reviews => _account.reviews;
  int get unreadNotificationCount =>
      notifications.where((item) => !item.isRead).length;
  CustomerAddress? get selectedAddress {
    for (final address in addresses) {
      if (address.id == _account.selectedAddressId) return address;
    }
    return null;
  }

  CustomerOrder orderById(String id) =>
      orders.firstWhere((order) => order.id == id);
  CustomerReview? reviewFor(String productId) {
    for (final review in reviews) {
      if (review.productId == productId) return review;
    }
    return null;
  }

  int availableStock(Product product) => math.max(
    0,
    product.stock -
        orders
            .expand((order) => order.lines)
            .where((line) => line.productId == product.id)
            .fold<int>(0, (sum, line) => sum + line.quantity),
  );

  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return result;
  }

  Future<void> _commit(CustomerAccount next) async {
    await _accountRepository.save(next);
    _account = next;
    if (!_disposed) notifyListeners();
  }

  Future<CustomerAddress> saveAddress({
    String? id,
    required String department,
    required String province,
    required String district,
    required String street,
  }) => _enqueue(() async {
    final fields = [
      department,
      province,
      district,
      street,
    ].map((value) => value.trim()).toList();
    if (fields.any((value) => value.isEmpty) ||
        fields.any((value) => value.length > 200)) {
      throw ArgumentError(
        'Completa departamento, provincia, distrito y dirección.',
      );
    }
    if (id != null && !addresses.any((address) => address.id == id)) {
      throw StateError('La dirección ya no está disponible.');
    }
    final address = CustomerAddress(
      id: id ?? 'DIR-${_account.sequence}',
      department: fields[0],
      province: fields[1],
      district: fields[2],
      street: fields[3],
    );
    final next = id == null
        ? [...addresses, address]
        : addresses.map((item) => item.id == id ? address : item).toList();
    await _commit(
      _account.copyWith(
        addresses: next,
        selectedAddressId: selectedAddress == null ? address.id : null,
        sequence: id == null ? _account.sequence + 1 : null,
      ),
    );
    return address;
  });
  Future<void> selectAddress(String id) => _enqueue(() async {
    if (!addresses.any((address) => address.id == id)) {
      throw StateError('Selecciona una dirección guardada.');
    }
    await _commit(_account.copyWith(selectedAddressId: id));
  });
  Future<void> deleteAddress(String id) => _enqueue(() async {
    final next = addresses.where((address) => address.id != id).toList();
    await _commit(
      _account.copyWith(
        addresses: next,
        selectedAddressId: selectedAddress?.id == id && next.isNotEmpty
            ? next.first.id
            : null,
        clearSelectedAddress: next.isEmpty,
      ),
    );
  });

  Future<CustomerOrder> placeOrder() {
    if (_checkoutPending) {
      return Future.error(StateError('El pedido ya se está procesando.'));
    }
    _checkoutPending = true;
    notifyListeners();
    return _enqueue(() async {
      try {
        if (items.isEmpty) throw StateError('Tu carrito está vacío.');
        final address = selectedAddress;
        if (address == null) {
          throw StateError('Selecciona una dirección de entrega.');
        }
        if (items.any((item) => item.quantity > availableStock(item.product))) {
          throw StateError('Revisa las cantidades disponibles de tu carrito.');
        }
        final now = DateTime.now().toUtc();
        final order = CustomerOrder(
          id: 'CM-${_account.sequence.toString().padLeft(6, '0')}',
          createdAt: now,
          address: address,
          lines: items.map(OrderLine.fromCart).toList(),
          shippingCents: shippingCents,
          events: [OrderEvent(OrderStatus.received, now)],
        );
        final notice = CustomerNotification(
          id: '${order.id}-received',
          orderId: order.id,
          title: 'Pedido realizado',
          message: 'Tu pedido ${order.id} se realizó con éxito.',
          createdAt: now,
        );
        await _commit(
          _account.copyWith(
            orders: [order, ...orders],
            notifications: [notice, ...notifications],
            sequence: _account.sequence + 1,
          ),
        );
        _cart.clear();
        return order;
      } finally {
        _checkoutPending = false;
        if (!_disposed) notifyListeners();
      }
    });
  }

  Future<void> updateOrderStatus(String id, OrderStatus status) =>
      _enqueue(() async {
        final order = orderById(id);
        if (order.status == status) return;
        if (status.index < order.status.index) {
          throw StateError('El estado del pedido no puede retroceder.');
        }
        final now = DateTime.now().toUtc();
        final notice = CustomerNotification(
          id: '$id-${status.name}',
          orderId: id,
          title: status.label,
          message: 'Tu pedido $id: ${status.label.toLowerCase()}.',
          createdAt: now,
        );
        await _commit(
          _account.copyWith(
            orders: orders
                .map(
                  (item) =>
                      item.id == id ? order.withStatus(status, now) : item,
                )
                .toList(),
            notifications: [notice, ...notifications],
          ),
        );
      });
  Future<void> markNotificationRead(String id) => _enqueue(() async {
    await _commit(
      _account.copyWith(
        notifications: notifications
            .map((item) => item.id == id ? item.read() : item)
            .toList(),
      ),
    );
  });
  Future<void> markAllNotificationsRead() => _enqueue(() async {
    await _commit(
      _account.copyWith(
        notifications: notifications.map((item) => item.read()).toList(),
      ),
    );
  });
  Future<void> saveReview({
    required String productId,
    required int rating,
    required String comment,
  }) => _enqueue(() async {
    final product = products.firstWhere((product) => product.id == productId);
    if (rating < 1 ||
        rating > 5 ||
        comment.trim().length < 3 ||
        comment.trim().length > 1000) {
      throw ArgumentError(
        'Elige de 1 a 5 estrellas y escribe una reseña de 3 a 1000 caracteres.',
      );
    }
    final review = CustomerReview(
      productId: productId,
      productName: product.name,
      rating: rating,
      comment: comment.trim(),
      createdAt: DateTime.now().toUtc(),
    );
    await _commit(
      _account.copyWith(
        reviews: [
          review,
          ...reviews.where((item) => item.productId != productId),
        ],
      ),
    );
  });
  Future<void> deleteReview(String productId) => _enqueue(() async {
    await _commit(
      _account.copyWith(
        reviews: reviews
            .where((review) => review.productId != productId)
            .toList(),
      ),
    );
  });

  List<CartItem> get items => _cart.items;
  int get cartCount => _cart.count;
  int get subtotalCents => _cart.subtotalCents;
  int get shippingCents => _cart.shippingCents;
  int get totalCents => _cart.totalCents;
  int quantityOf(String id) => _cart.quantityOf(id);
  bool isFavorite(String id) => _favorites.contains(id);

  ProductSubcategory subcategoryFor(Product product) =>
      _subcategoriesById[product.subcategoryId]!;
  ProductCategory categoryFor(Product product) =>
      _categoriesById[subcategoryFor(product).categoryId]!;
  List<ProductSubcategory> subcategoriesForCategory(String categoryId) =>
      List.unmodifiable(
        subcategories.where(
          (subcategory) => subcategory.categoryId == categoryId,
        ),
      );
  List<Product> productsForCategory(String categoryId) => List.unmodifiable(
    products.where((product) => categoryFor(product).id == categoryId),
  );
  List<Product> productsForSubcategory(String subcategoryId) =>
      List.unmodifiable(
        products.where((product) => product.subcategoryId == subcategoryId),
      );

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void add(Product product, [int quantity = 1]) {
    if (_checkoutPending || quantity <= 0 || availableStock(product) == 0) {
      return;
    }
    _cart.setQuantity(
      product,
      math.min(quantityOf(product.id) + quantity, availableStock(product)),
    );
    notifyListeners();
  }

  void setQuantity(Product product, int quantity) {
    if (_checkoutPending) return;
    _cart.setQuantity(product, math.min(quantity, availableStock(product)));
    notifyListeners();
  }

  void remove(String id) {
    if (_checkoutPending) return;
    _cart.remove(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
