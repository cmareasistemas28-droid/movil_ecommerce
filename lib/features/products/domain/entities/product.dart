class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceCents,
    required this.rating,
    required this.description,
    required this.specifications,
    required this.art,
    this.oldPriceCents,
    this.stock = 12,
  });

  final String id;
  final String name;
  final String category;
  final int priceCents;
  final int? oldPriceCents;
  final double rating;
  final String description;
  final Map<String, String> specifications;
  final String art;
  final int stock;
}
