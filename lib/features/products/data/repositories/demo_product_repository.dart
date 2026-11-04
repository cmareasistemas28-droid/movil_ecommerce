import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class DemoProductRepository implements ProductRepository {
  const DemoProductRepository();

  @override
  List<Product> getProducts() => const [
    Product(
      id: 'audio-01',
      name: 'Parlantes Studio 2.0',
      category: 'Audio',
      priceCents: 12900,
      oldPriceCents: 15900,
      rating: 4.8,
      art: 'speakers',
      description: 'Dale más vida a tu escritorio. Un par de parlantes compactos con sonido estéreo y control de volumen al alcance de tu mano.',
      specifications: {
        'Potencia': '10 W RMS',
        'Conexión': 'USB + jack 3.5 mm',
        'Canales': 'Estéreo 2.0',
        'Color': 'Grafito',
      },
    ),
    Product(
      id: 'gpu-01',
      name: 'Tarjeta gráfica Nova 8 GB',
      category: 'Componentes',
      priceCents: 119900,
      oldPriceCents: 134900,
      rating: 4.9,
      art: 'gpu',
      stock: 5,
      description: 'Tu siguiente nivel empieza aquí. Gráficos fluidos y refrigeración de doble ventilador para tus juegos y proyectos creativos.',
      specifications: {
        'Memoria': '8 GB GDDR6',
        'Interfaz': 'PCIe 4.0',
        'Salidas': 'HDMI + DisplayPort',
        'Refrigeración': 'Doble ventilador',
      },
    ),
    Product(
      id: 'cable-01',
      name: 'Cable USB-C trenzado',
      category: 'Cables',
      priceCents: 2900,
      rating: 4.7,
      art: 'cable',
      description: 'Conecta tu día a día. Cable flexible con acabado trenzado para cargar y sincronizar tus dispositivos compatibles.',
      specifications: {
        'Conectores': 'USB-C a USB-C',
        'Longitud': '1.5 m',
        'Potencia máxima': '60 W',
        'Acabado': 'Trenzado reforzado',
      },
    ),
    Product(
      id: 'keyboard-01',
      name: 'Teclado mecánico Air',
      category: 'Periféricos',
      priceCents: 18900,
      oldPriceCents: 22900,
      rating: 4.8,
      art: 'keyboard',
      description: 'Más espacio para tus ideas. Teclado compacto de pulsación precisa, con iluminación y un diseño pensado para tu escritorio.',
      specifications: {
        'Formato': 'Compacto 75 %',
        'Distribución': 'Español',
        'Conexión': 'USB-C con cable',
        'Interruptores': 'Mecánicos lineales',
      },
    ),
    Product(
      id: 'ssd-01',
      name: 'SSD Velocity 1 TB',
      category: 'Componentes',
      priceCents: 25900,
      rating: 4.9,
      art: 'ssd',
      description: 'Menos esperas, más posibilidades. Almacenamiento rápido para tu sistema, aplicaciones y biblioteca de juegos.',
      specifications: {
        'Capacidad': '1 TB',
        'Formato': 'M.2 2280',
        'Interfaz': 'NVMe PCIe 3.0',
        'Lectura': 'Hasta 3500 MB/s',
      },
    ),
    Product(
      id: 'headphones-01',
      name: 'Audífonos Pulse',
      category: 'Audio',
      priceCents: 14900,
      rating: 4.6,
      art: 'headphones',
      description: 'Encuentra tu ritmo. Audífonos cómodos para acompañarte mientras trabajas, estudias o disfrutas de tu música.',
      specifications: {
        'Conexión': 'Bluetooth 5.3',
        'Autonomía': 'Hasta 30 horas',
        'Micrófono': 'Integrado',
        'Diseño': 'Circumaural',
      },
    ),
  ];
}
