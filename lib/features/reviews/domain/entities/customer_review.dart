class CustomerReview {
  const CustomerReview({
    required this.productId,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  final String productId;
  final String productName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };
  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    productId: json['productId'] as String,
    productName: json['productName'] as String,
    rating: json['rating'] as int,
    comment: json['comment'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
