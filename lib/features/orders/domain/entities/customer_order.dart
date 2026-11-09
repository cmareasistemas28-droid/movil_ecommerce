import '../../../addresses/domain/entities/customer_address.dart';
import '../../../cart/domain/entities/shopping_cart.dart';

enum OrderStatus {
  received('Pedido recibido'),
  preparing('En preparación'),
  ready('Listo para enviar'),
  onTheWay('En camino'),
  delivered('Entregado');

  const OrderStatus(this.label);
  final String label;
}

class OrderLine {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.unitPriceCents,
    required this.quantity,
    required this.imageAsset,
  });
  final String productId;
  final String name;
  final int unitPriceCents;
  final int quantity;
  final String imageAsset;
  int get totalCents => unitPriceCents * quantity;
  factory OrderLine.fromCart(CartItem item) => OrderLine(
    productId: item.product.id,
    name: item.product.name,
    unitPriceCents: item.product.priceCents,
    quantity: item.quantity,
    imageAsset: item.product.imageAssets.isEmpty
        ? 'assets/images/products/${item.product.art}.png'
        : item.product.imageAssets.first,
  );
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'unitPriceCents': unitPriceCents,
    'quantity': quantity,
    'imageAsset': imageAsset,
  };
  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
    productId: json['productId'] as String,
    name: json['name'] as String,
    unitPriceCents: json['unitPriceCents'] as int,
    quantity: json['quantity'] as int,
    imageAsset: json['imageAsset'] as String,
  );
}

class OrderEvent {
  const OrderEvent(this.status, this.at);
  final OrderStatus status;
  final DateTime at;
  Map<String, dynamic> toJson() => {
    'status': status.name,
    'at': at.toIso8601String(),
  };
  factory OrderEvent.fromJson(Map<String, dynamic> json) => OrderEvent(
    OrderStatus.values.byName(json['status'] as String),
    DateTime.parse(json['at'] as String),
  );
}

class CustomerOrder {
  CustomerOrder({
    required this.id,
    required this.createdAt,
    required this.address,
    required List<OrderLine> lines,
    required this.shippingCents,
    required List<OrderEvent> events,
  }) : lines = List.unmodifiable(lines),
       events = List.unmodifiable(events);
  final String id;
  final DateTime createdAt;
  final CustomerAddress address;
  final List<OrderLine> lines;
  final int shippingCents;
  final List<OrderEvent> events;
  OrderStatus get status => events.last.status;
  int get quantity => lines.fold(0, (sum, line) => sum + line.quantity);
  int get subtotalCents => lines.fold(0, (sum, line) => sum + line.totalCents);
  int get totalCents => subtotalCents + shippingCents;
  CustomerOrder withStatus(OrderStatus status, DateTime at) => CustomerOrder(
    id: id,
    createdAt: createdAt,
    address: address,
    lines: lines,
    shippingCents: shippingCents,
    events: [...events, OrderEvent(status, at)],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'address': address.toJson(),
    'lines': lines.map((line) => line.toJson()).toList(),
    'shippingCents': shippingCents,
    'events': events.map((event) => event.toJson()).toList(),
  };
  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    address: CustomerAddress.fromJson(
      Map<String, dynamic>.from(json['address'] as Map),
    ),
    lines: (json['lines'] as List)
        .map(
          (line) => OrderLine.fromJson(Map<String, dynamic>.from(line as Map)),
        )
        .toList(),
    shippingCents: json['shippingCents'] as int,
    events: (json['events'] as List)
        .map(
          (event) =>
              OrderEvent.fromJson(Map<String, dynamic>.from(event as Map)),
        )
        .toList(),
  );
}
