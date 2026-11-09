import '../../domain/entities/product.dart';

// Source descriptions/prices: the four user-provided PRODUCTOS folders.
const _printerBases = [
  Product(
    id: 'hp-smart-tank-315',
    name: 'Impresora HP Smart Tank 315',
    subcategoryId: 'multifuncionales',
    priceCents: 65000,
    oldPriceCents: 75000,
    rating: 4.8,
    art: 'hp-315',
    imageAssets: [
      'assets/images/printers/hp-315-1.jpg',
      'assets/images/printers/hp-315-2.jpg',
      'assets/images/printers/hp-315-3.jpg',
    ],
    description: 'Impresora multifuncional ideal para el hogar, estudiantes y oficinas. Imprime a color y cuenta con sistema de tanque de tinta recargable para tus trabajos y documentos diarios. Disponible en CIBER-MAX, Huancayo.',
    specifications: {
      'Modelo': 'HP Smart Tank 315',
      'Funciones': 'Impresión, copia y escaneo',
      'Impresión': 'A color',
      'Sistema de tinta': 'Tanque recargable',
      'Uso recomendado': 'Hogar, estudio y oficina',
    },
  ),
  Product(
    id: 'epson-ecotank-l3110',
    name: 'Impresora Epson EcoTank L3110',
    subcategoryId: 'multifuncionales',
    priceCents: 74000,
    rating: 4.7,
    art: 'epson-l3110',
    imageAssets: [
      'assets/images/printers/epson-l3110-1.jpg',
      'assets/images/printers/epson-l3110-2.jpg',
      'assets/images/printers/epson-l3110-3.jpg',
    ],
    description: 'Calidad y ahorro para tu hogar, estudio u oficina. Multifuncional 3 en 1 que imprime, copia y escanea a color y en blanco y negro. Su sistema EcoTank de tinta continua y sus tanques frontales de fácil llenado ofrecen bajo costo de impresión para documentos y trabajos. Disponible en CIBER-MAX, Huancayo.',
    specifications: {
      'Modelo': 'Epson EcoTank L3110',
      'Funciones': 'Impresión, copia y escaneo',
      'Impresión': 'Color y blanco y negro',
      'Sistema de tinta': 'EcoTank de tinta continua',
      'Tanques': 'Frontales de fácil llenado',
    },
  ),
  Product(
    id: 'epson-ecotank-l3160',
    name: 'Impresora Epson EcoTank L3160 Wi-Fi',
    subcategoryId: 'impresoras-wifi',
    priceCents: 95000,
    oldPriceCents: 109000,
    rating: 4.9,
    art: 'epson-l3160',
    imageAssets: [
      'assets/images/printers/epson-l3160-1.jpg',
      'assets/images/printers/epson-l3160-2.jpg',
      'assets/images/printers/epson-l3160-3.jpg',
    ],
    description: 'Calidad, conectividad y ahorro para tu hogar, estudio u oficina. Multifuncional que imprime a color y en blanco y negro, copia y escanea. Incluye sistema EcoTank recargable, conexión Wi-Fi y Wi-Fi Direct, y pantalla LCD a color de 1,44 pulgadas. Disponible en CIBER-MAX, Huancayo.',
    specifications: {
      'Modelo': 'Epson EcoTank L3160',
      'Funciones': 'Impresión, copia y escaneo',
      'Impresión': 'Color y blanco y negro',
      'Sistema de tinta': 'EcoTank recargable',
      'Conectividad': 'Wi-Fi y Wi-Fi Direct',
      'Pantalla': 'LCD a color de 1,44 pulgadas',
    },
  ),
  Product(
    id: 'hp-smart-tank-515',
    name: 'Impresora HP Smart Tank 515 Wi-Fi',
    subcategoryId: 'impresoras-wifi',
    priceCents: 85000,
    rating: 4.8,
    art: 'hp-515',
    imageAssets: [
      'assets/images/printers/hp-515-1.jpg',
      'assets/images/printers/hp-515-2.jpg',
      'assets/images/printers/hp-515-3.jpg',
    ],
    description: 'Calidad, rendimiento y conectividad para tu hogar, estudio u oficina. Imprime a color y en blanco y negro, copia y escanea con tanque de tinta recargable de alta capacidad. Cuenta con Wi-Fi, Wi-Fi Direct e impresión desde dispositivos móviles mediante HP Smart. Disponible en CIBER-MAX, Huancayo.',
    specifications: {
      'Modelo': 'HP Smart Tank 515',
      'Funciones': 'Impresión, copia y escaneo',
      'Impresión': 'Color y blanco y negro',
      'Sistema de tinta': 'Tanque recargable de alta capacidad',
      'Conectividad': 'Wi-Fi y Wi-Fi Direct',
      'Aplicación móvil': 'HP Smart',
    },
  ),
];

List<Product> createPrinterExamples() => [
  for (var copy = 0; copy < 20; copy++)
    for (final base in _printerBases)
      Product(
        id: copy == 0 ? base.id : '${base.id}-demo-${copy + 1}',
        name: copy == 0
            ? base.name
            : '${base.name} · Demo ${(copy + 1).toString().padLeft(2, '0')}',
        subcategoryId: base.subcategoryId,
        priceCents: base.priceCents,
        oldPriceCents: copy == 0
            ? base.oldPriceCents
            : copy % 3 == 0
            ? base.priceCents + 10000
            : null,
        rating: base.rating,
        art: base.art,
        imageAssets: base.imageAssets,
        description: base.description,
        specifications: base.specifications,
        stock: base.stock,
      ),
];
