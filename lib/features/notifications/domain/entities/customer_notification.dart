class CustomerNotification {
  const CustomerNotification({
    required this.id,
    required this.orderId,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
  final String id;
  final String orderId;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  CustomerNotification read() => CustomerNotification(
    id: id,
    orderId: orderId,
    title: title,
    message: message,
    createdAt: createdAt,
    isRead: true,
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'title': title,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };
  factory CustomerNotification.fromJson(Map<String, dynamic> json) =>
      CustomerNotification(
        id: json['id'] as String,
        orderId: json['orderId'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isRead: json['isRead'] as bool,
      );
}
