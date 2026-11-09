import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cibermax_movil/app/store/shop_controller.dart';
import 'package:cibermax_movil/app/store/customer_account.dart';
import 'package:cibermax_movil/app/data/preferences_customer_account_repository.dart';
import 'package:cibermax_movil/features/categories/data/repositories/demo_category_repository.dart';
import 'package:cibermax_movil/features/products/data/repositories/demo_product_repository.dart';
import 'package:cibermax_movil/features/orders/domain/entities/customer_order.dart';

ShopController controller([CustomerAccountRepository? repository]) =>
    ShopController(
      const DemoProductRepository(),
      categoriesRepository: const DemoCategoryRepository(),
      accountRepository: repository,
    );

class FailingAccountRepository extends MemoryCustomerAccountRepository {
  bool fail = false;
  @override
  Future<void> save(CustomerAccount account) async {
    if (fail) throw StateError('No se pudo guardar.');
    await super.save(account);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('checkout requires address and items, persists a price/address snapshot and clears cart', () async {
    final shop = controller();
    addTearDown(shop.dispose);
    await expectLater(shop.placeOrder(), throwsStateError);
    shop.add(shop.products.first, 2);
    await expectLater(shop.placeOrder(), throwsStateError);
    expect(shop.cartCount, 2);
    final first = await shop.saveAddress(
      department: 'Junín',
      province: 'Huancayo',
      district: 'El Tambo',
      street: 'Av. Uno 123',
    );
    final second = await shop.saveAddress(
      department: 'Lima',
      province: 'Lima',
      district: 'Miraflores',
      street: 'Av. Dos 456',
    );
    await shop.selectAddress(second.id);
    final orderFuture = shop.placeOrder();
    await expectLater(shop.placeOrder(), throwsStateError);
    final order = await orderFuture;
    expect(order.address.id, second.id);
    expect(order.subtotalCents, 130000);
    expect(order.shippingCents, 0);
    expect(order.totalCents, 130000);
    expect(order.lines.single.quantity, 2);
    expect(shop.cartCount, 0);
    expect(shop.availableStock(shop.products.first), 10);
    expect(shop.notifications.single.title, 'Pedido realizado');
    await shop.saveAddress(
      id: second.id,
      department: 'Lima',
      province: 'Lima',
      district: 'Miraflores',
      street: 'Av. Editada 789',
    );
    await shop.deleteAddress(second.id);
    expect(shop.selectedAddress?.id, first.id);
    expect(shop.orderById(order.id).address.street, 'Av. Dos 456');
    expect(() => order.lines.clear(), throwsUnsupportedError);
    expect(() => shop.orders.clear(), throwsUnsupportedError);
  });

  test('failed persistence keeps cart, order history and address unchanged and allows retry', () async {
    final repository = FailingAccountRepository();
    final shop = controller(repository);
    addTearDown(shop.dispose);
    await shop.saveAddress(
      department: 'Junín',
      province: 'Huancayo',
      district: 'Huancayo',
      street: 'Jr. A 123',
    );
    shop.add(shop.products.first);
    repository.fail = true;
    await expectLater(shop.placeOrder(), throwsStateError);
    expect(shop.cartCount, 1);
    expect(shop.orders, isEmpty);
    expect(shop.notifications, isEmpty);
    expect(shop.checkoutInProgress, isFalse);
    await expectLater(
      shop.saveAddress(
        department: 'Lima',
        province: 'Lima',
        district: 'Lima',
        street: 'Jr. B',
      ),
      throwsStateError,
    );
    expect(shop.addresses.length, 1);
    repository.fail = false;
    await shop.placeOrder();
    expect(shop.orders.length, 1);
    expect(shop.cartCount, 0);
  });

  test('status updates create distinct notifications, ignore duplicates and reject regressions', () async {
    final shop = controller();
    addTearDown(shop.dispose);
    await shop.saveAddress(
      department: 'Junín',
      province: 'Huancayo',
      district: 'Huancayo',
      street: 'Jr. A',
    );
    shop.add(shop.products.first);
    final order = await shop.placeOrder();
    await shop.updateOrderStatus(order.id, OrderStatus.ready);
    await shop.updateOrderStatus(order.id, OrderStatus.ready);
    await shop.updateOrderStatus(order.id, OrderStatus.onTheWay);
    expect(shop.notifications.map((item) => item.title), [
      'En camino',
      'Listo para enviar',
      'Pedido realizado',
    ]);
    expect(shop.orderById(order.id).status, OrderStatus.onTheWay);
    await expectLater(
      shop.updateOrderStatus(order.id, OrderStatus.received),
      throwsStateError,
    );
    await shop.markNotificationRead(shop.notifications.first.id);
    expect(shop.unreadNotificationCount, 2);
    await shop.markAllNotificationsRead();
    expect(shop.unreadNotificationCount, 0);
  });

  test('device storage restores addresses, order snapshots, read notices, own reviews and inventory', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = PreferencesCustomerAccountRepository(preferences);
    final shop = controller(repository);
    await shop.saveAddress(
      department: 'Junín',
      province: 'Huancayo',
      district: 'El Tambo',
      street: 'Av. Prueba 10',
    );
    shop.add(shop.products.first, 2);
    final order = await shop.placeOrder();
    await shop.updateOrderStatus(order.id, OrderStatus.ready);
    await shop.markAllNotificationsRead();
    await shop.saveReview(
      productId: shop.products.first.id,
      rating: 5,
      comment: 'Buena calidad de impresión.',
    );
    shop.dispose();
    final restored = controller(
      PreferencesCustomerAccountRepository(preferences),
    );
    addTearDown(restored.dispose);
    expect(restored.selectedAddress?.street, 'Av. Prueba 10');
    expect(restored.orders.single.totalCents, 130000);
    expect(restored.orders.single.status, OrderStatus.ready);
    expect(restored.unreadNotificationCount, 0);
    expect(restored.reviews.single.rating, 5);
    expect(restored.reviews.single.comment, 'Buena calidad de impresión.');
    restored.add(restored.products.first, 100);
    expect(restored.cartCount, 10);
    await expectLater(
      restored.saveReview(
        productId: restored.products.first.id,
        rating: 0,
        comment: 'Mal',
      ),
      throwsArgumentError,
    );
    await restored.saveReview(
      productId: restored.products.first.id,
      rating: 4,
      comment: 'Actualicé mi reseña.',
    );
    expect(restored.reviews.length, 1);
    await restored.deleteReview(restored.products.first.id);
    expect(restored.reviews, isEmpty);
  });
}
