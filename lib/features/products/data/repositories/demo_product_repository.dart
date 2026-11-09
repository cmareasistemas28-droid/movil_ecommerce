import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'printer_demo_products.dart';

class DemoProductRepository implements ProductRepository {
  const DemoProductRepository();

  @override
  List<Product> getProducts() => createPrinterExamples();
}
