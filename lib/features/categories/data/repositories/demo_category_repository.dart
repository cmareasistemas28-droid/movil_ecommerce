import '../../domain/entities/product_category.dart';
import '../../domain/entities/product_subcategory.dart';
import '../../domain/repositories/category_repository.dart';

class DemoCategoryRepository implements CategoryRepository {
  const DemoCategoryRepository();

  @override
  List<ProductCategory> getCategories() => const [
    ProductCategory(
      id: 'impresoras',
      name: 'Impresoras',
      description: 'Impresión, copia y escaneo para tu hogar u oficina.',
    ),
    ProductCategory(
      id: 'perifericos',
      name: 'Periféricos',
      description: 'Todo para completar tu escritorio.',
    ),
    ProductCategory(
      id: 'audio',
      name: 'Audio',
      description: 'Encuentra el sonido que va contigo.',
    ),
    ProductCategory(
      id: 'componentes',
      name: 'Componentes',
      description: 'Potencia y espacio para tu equipo.',
    ),
    ProductCategory(
      id: 'cables',
      name: 'Cables',
      description: 'Conecta tus dispositivos.',
    ),
  ];

  @override
  List<ProductSubcategory> getSubcategories() => const [
    ProductSubcategory(
      id: 'multifuncionales',
      categoryId: 'impresoras',
      name: 'Multifuncionales',
    ),
    ProductSubcategory(
      id: 'impresoras-wifi',
      categoryId: 'impresoras',
      name: 'Multifuncionales con Wi-Fi',
    ),
    ProductSubcategory(
      id: 'teclados',
      categoryId: 'perifericos',
      name: 'Teclados',
    ),
    ProductSubcategory(id: 'mouse', categoryId: 'perifericos', name: 'Mouse'),
    ProductSubcategory(id: 'parlantes', categoryId: 'audio', name: 'Parlantes'),
    ProductSubcategory(id: 'audifonos', categoryId: 'audio', name: 'Audífonos'),
    ProductSubcategory(
      id: 'tarjetas-graficas',
      categoryId: 'componentes',
      name: 'Tarjetas gráficas',
    ),
    ProductSubcategory(
      id: 'almacenamiento',
      categoryId: 'componentes',
      name: 'Almacenamiento',
    ),
    ProductSubcategory(
      id: 'cables-usb',
      categoryId: 'cables',
      name: 'Cables USB',
    ),
    ProductSubcategory(
      id: 'cables-hdmi',
      categoryId: 'cables',
      name: 'Cables HDMI',
    ),
  ];
}
