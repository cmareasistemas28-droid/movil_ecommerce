class Product {
  const Product({
    required this.id,
    required this.name,
    required this.subcategoryId,
    required this.priceCents,
    required this.rating,
    required this.description,
    required this.specifications,
    required this.art,
    this.oldPriceCents,
    this.stock = 12,
    this.imageAssets = const [],
  });

  final String id;
  final String name;
  final String subcategoryId;
  final int priceCents;
  final int? oldPriceCents;
  final double rating;
  final String description;
  final Map<String, String> specifications;
  final String art;
  final int stock;
  final List<String> imageAssets;
}
