import '../../features/addresses/domain/entities/customer_address.dart';
import '../../features/orders/domain/entities/customer_order.dart';
import '../../features/notifications/domain/entities/customer_notification.dart';
import '../../features/reviews/domain/entities/customer_review.dart';

class CustomerAccount {
  CustomerAccount({
    List<CustomerAddress> addresses = const [],
    List<CustomerOrder> orders = const [],
    List<CustomerNotification> notifications = const [],
    List<CustomerReview> reviews = const [],
    this.selectedAddressId,
    this.sequence = 1,
  }) : addresses = List.unmodifiable(addresses),
       orders = List.unmodifiable(orders),
       notifications = List.unmodifiable(notifications),
       reviews = List.unmodifiable(reviews);
  final List<CustomerAddress> addresses;
  final List<CustomerOrder> orders;
  final List<CustomerNotification> notifications;
  final List<CustomerReview> reviews;
  final String? selectedAddressId;
  final int sequence;
  CustomerAccount copyWith({
    List<CustomerAddress>? addresses,
    List<CustomerOrder>? orders,
    List<CustomerNotification>? notifications,
    List<CustomerReview>? reviews,
    String? selectedAddressId,
    bool clearSelectedAddress = false,
    int? sequence,
  }) => CustomerAccount(
    addresses: addresses ?? this.addresses,
    orders: orders ?? this.orders,
    notifications: notifications ?? this.notifications,
    reviews: reviews ?? this.reviews,
    selectedAddressId: clearSelectedAddress
        ? null
        : selectedAddressId ?? this.selectedAddressId,
    sequence: sequence ?? this.sequence,
  );
  Map<String, dynamic> toJson() => {
    'version': 1,
    'sequence': sequence,
    'selectedAddressId': selectedAddressId,
    'addresses': addresses.map((item) => item.toJson()).toList(),
    'orders': orders.map((item) => item.toJson()).toList(),
    'notifications': notifications.map((item) => item.toJson()).toList(),
    'reviews': reviews.map((item) => item.toJson()).toList(),
  };
  factory CustomerAccount.fromJson(
    Map<String, dynamic> json,
  ) => CustomerAccount(
    sequence: json['sequence'] as int,
    selectedAddressId: json['selectedAddressId'] as String?,
    addresses: (json['addresses'] as List)
        .map(
          (item) =>
              CustomerAddress.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    orders: (json['orders'] as List)
        .map(
          (item) =>
              CustomerOrder.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    notifications: (json['notifications'] as List)
        .map(
          (item) => CustomerNotification.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(),
    reviews: (json['reviews'] as List)
        .map(
          (item) =>
              CustomerReview.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
  );
}

abstract interface class CustomerAccountRepository {
  CustomerAccount load();
  Future<void> save(CustomerAccount account);
}

class MemoryCustomerAccountRepository implements CustomerAccountRepository {
  CustomerAccount _account = CustomerAccount();
  @override
  CustomerAccount load() => _account;
  @override
  Future<void> save(CustomerAccount account) async => _account = account;
}
