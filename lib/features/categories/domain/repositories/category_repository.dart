import '../entities/product_category.dart';
import '../entities/product_subcategory.dart';

abstract interface class CategoryRepository {
  List<ProductCategory> getCategories();
  List<ProductSubcategory> getSubcategories();
}
