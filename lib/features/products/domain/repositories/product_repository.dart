import '../entities/product.dart';

abstract interface class ProductRepository {
  List<Product> getProducts();
}
