# Cibermax Móvil

Aplicación Flutter organizada por funcionalidades, con separación de presentación, dominio y datos.

La presentación actual adapta exclusivamente el diseño de las nueve referencias visuales aportadas: coral #FF593C, superficies blancas sobre fondo casi blanco, sombras suaves, esquinas de 18 px, botones cápsula, texto compacto e iconos finos. Conserva el contenido, las fotografías de impresoras, los textos en español, las cinco pestañas y las funciones del proyecto; Inicio permanece vacío.

## Interfaz basada en las capturas de referencia

Inicio queda vacío por solicitud del usuario: no muestra dirección, carrito superior, buscador, categorías de servicios ni promociones. La barra inferior conserva Inicio, Productos, Carrito, Pedidos y Perfil. Perfil abre el menú de cuenta, compras e información a pantalla completa.

- `features/home/presentation/pages/home_page.dart`: inicio y coordinación de la maqueta de sesión/tema.
- `shared/widgets/shop_bottom_navigation.dart`: barra inferior blanca/rojo coral con cinco destinos y contador del carrito. Productos muestra buscador, categorías y subcategorías en filas horizontales y productos en la misma pantalla. Pedidos muestra las compras confirmadas y permite abrir su detalle. Carrito integra la pantalla existente manteniendo la barra visible; «Explorar productos» abre Productos.
- `features/profile/presentation/widgets/customer_drawer.dart`: perfil de ancho completo con tarjeta de identidad, estadísticas calculadas de pedidos/favoritos/reseñas y grupos de opciones en tarjetas con separadores. La navegación inferior sigue visible, con Perfil seleccionado. No usa animación de apertura; todas las opciones y la versión del proyecto se conservan.
- `features/profile/presentation/pages/profile_page.dart`: «Mi perfil», avatar y nombre, nombres, apellidos, tipo/número de documento, fecha de nacimiento, edad calculada, dos celulares, correo bloqueado y contraseña de vista previa. Cada dato editable abre una pantalla con cabecera «Mi perfil», descripción, tarjeta de borde redondeado, campo gris y botón rojo coral para guardar. Tipo y número de documento comparten una pantalla (DNI/CIP), y fecha de nacimiento/edad comparten el editor de fecha con calendario integrado. Volver sin guardar descarta los cambios. La edición es local, sin guardar en una cuenta real; el correo permanece de solo lectura. Solo se conserva un indicador de contraseña editada, no su texto. No se muestran código, fecha de registro ni interruptor de notificaciones. Se conserva el cierre de sesión.
- `app/theme/app_theme.dart`: tema blanco/rojo coral y variante oscura de la referencia. Los datos personales y la versión que aparecen son contenido estático copiado de las capturas, no información consultada a una cuenta ni la versión real del paquete.
- `assets/images/reference/`: ilustraciones y promociones extraídas de los archivos aportados; procedencia y límites de resolución en su README.

El catálogo se abre desde la pestaña Productos. El menú se organiza en «Mi cuenta» (Mi perfil, Mis direcciones, Notificaciones), «Tus compras» (Mis pedidos, Mis favoritos, Devoluciones, Mis reseñas), «Ayuda» (Ayuda y soporte) e «Información» (Facebook, Instagram, WhatsApp, Libro de reclamaciones, Términos y condiciones y Cerrar sesión). El pie muestra `V1.0.0.0.1`. Las opciones sin recorrido implementado son visuales y no están conectadas a servicios externos. El splash existente se mantiene porque las referencias no incluyen una pantalla de arranque nueva.

«Mis favoritos» muestra únicamente los productos guardados con el corazón, sin buscador, categorías ni subcategorías, sin aplicar filtros del catálogo. Quitar un favorito lo retira inmediatamente de la lista; cuando no quedan productos, aparece la indicación para guardarlos con el corazón.

La apertura/cierre del menú y el acceso a Mi perfil son inmediatos. `app/router/instant_page_route.dart` elimina las transiciones de entrada y salida de los editores del perfil y del catálogo accesible desde Mis favoritos. Direcciones, notificaciones, pedidos y reseñas usan las mismas transiciones inmediatas. El splash conserva su comportamiento original.

Las capturas de la implementación están en `design-review/reference-*.png`. Para regenerarlas con las fuentes del SDK:

```sh
flutter test test/reference_capture_test.dart --dart-define=CAPTURE_REFERENCE=true --dart-define=FONT_DIR=<flutter-sdk>/bin/cache/artifacts/material_fonts
```

Las capturas renderizadas no imitan la hora, batería o botones del sistema Android; esos elementos los dibuja el dispositivo. La resolución y las fuentes del teléfono pueden producir diferencias respecto de los JPG originales.

## Categorías y subcategorías

`features/categories/domain/` define categorías y subcategorías, y el repositorio de demostración en `data/` las proporciona. Cada producto guarda únicamente `subcategoryId`; la categoría se obtiene mediante `ProductSubcategory.categoryId`. `ShopController` recibe ambos repositorios, verifica las relaciones y proporciona las consultas del catálogo. No se duplican nombres de categoría dentro de los productos.

- Periféricos: Teclados y Mouse.
- Impresoras: Multifuncionales y Multifuncionales con Wi-Fi.
- Audio: Parlantes y Audífonos.
- Componentes: Tarjetas gráficas y Almacenamiento.
- Cables: Cables USB y Cables HDMI.

El catálogo contiene 80 impresoras basadas exclusivamente en los cuatro productos de la carpeta PRODUCTOS (20 entradas por modelo). Se retiraron los seis ejemplos tecnológicos anteriores. Se conservan los precios actuales y las descripciones aportadas; algunos ejemplos añaden un precio anterior ficticio para mostrar descuentos. El precio anterior aparece rojo y tachado; el precio actual se muestra oscuro y en negrita. Las copias llevan el sufijo Demo NN, IDs únicos y reutilizan las fotos y especificaciones del modelo. Stock y valoraciones son de demostración; no se muestra el número de unidades disponibles en el detalle, pero el carrito respeta el stock.

Cada impresora tiene una galería de tres fotos en su detalle. Las fotos se preparan en `assets/images/printers/`; los AVIF se convierten a JPEG mediante `tool/prepare_printer_assets.py`, preservando los originales. La procedencia se documenta en el README de esa carpeta. La grilla usa filas de construcción diferida para cargar el catálogo según se desplaza la pantalla.

El detalle comienza con una imagen a todo el ancho, sin barra de título; volver y favoritos se superponen a la foto. Debajo aparecen el nombre, precio, descripción, especificaciones y reseñas sobre la superficie blanca del tema claro. Se pueden escribir y editar reseñas propias, que también aparecen en Mis reseñas. `product_purchase_bar.dart` mantiene «Tu producto», el total según la cantidad, el selector y el botón «Agregar» visibles al desplazar la información; el selector respeta el stock restante y agrega esa cantidad al carrito local. Se mantienen las transiciones inmediatas.

Las superficies del tema usan blancos y grises neutros, sin tintes de color generados por Material. El buscador usa una cápsula blanca con sombra suave; los filtros seleccionados tienen fondo rojo coral, texto y marca blancos; los demás mantienen fondo blanco. Tanto las tarjetas como el detalle confirman las adiciones con «Se agregó al carrito»: texto pequeño, fondo transparente y duración de dos segundos, sin nombre del producto ni acción adicional. La línea del aviso queda reservada debajo de los controles para evitar superponerlo al contenido o desplazar los botones. Volver a agregar el mismo producto renueva el aviso.

La pestaña Productos reutiliza `features/products/presentation/pages/catalog_page.dart`: buscador arriba, una fila desplazable de categorías y otra de subcategorías, sin columnas de navegación ni páginas intermedias. «Todos» está seleccionado por defecto y muestra los 80 productos. Elegir una categoría actualiza sus subcategorías y selecciona «Todos» para mostrar todos sus productos; elegir una subcategoría afina el listado. La búsqueda se combina con ambos filtros. Las categorías ajenas a Impresoras muestran un estado vacío. El catálogo general mantiene estos filtros; Mis favoritos muestra solo los productos guardados. El detalle y el carrito usan cambios de página inmediatos.

## Estructura

- `lib/main.dart`: punto de entrada; inicia `CibermaxApp`.
- `lib/app/`: composición de la aplicación, rutas y tema. Aquí se puede incorporar la inyección de dependencias cuando sea necesaria.
- `lib/core/`: infraestructura común: configuración, red, errores, almacenamiento, constantes y utilidades. No depende de funcionalidades.
- `lib/features/`: auth, home, products, categories, search, cart, checkout, orders, favorites, addresses y profile.
- `lib/shared/`: widgets, extensiones y enumeraciones reutilizables entre funcionalidades. Los componentes específicos permanecen en su funcionalidad.
- `assets/`: imágenes, iconos y fuentes.
- `test/`: pruebas; al añadir pruebas de funcionalidades, reflejar la ruta de `lib/` (por ejemplo, `test/features/products/domain/usecases/`).

Cada funcionalidad dispone de:

```text
data/
  datasources/      # Acceso a API, base de datos o caché.
  models/           # Serialización y conversión hacia entidades.
  repositories/     # Implementaciones de contratos del dominio.
domain/
  entities/         # Objetos y reglas de negocio.
  repositories/     # Contratos independientes de infraestructura.
  usecases/         # Operaciones de negocio cuando aporten valor.
presentation/
  pages/            # Pantallas.
  providers/        # Estado y coordinación de la interfaz.
  widgets/          # Componentes propios de la funcionalidad.
```

## Reglas de organización

El dominio utiliza Dart puro, sin depender de Flutter, presentación o datos. Datos implementa los contratos del dominio; presentación consume el dominio. La conexión con implementaciones concretas se resuelve desde `app/`.

Evitar importar detalles internos de otra funcionalidad. Mover a `shared/` o `core/` únicamente elementos realmente compartidos. No crear servicios, repositorios ni casos de uso vacíos: las carpetas están preparadas para incorporar código conforme se implemente cada funcionalidad. Los archivos `.gitkeep` permiten conservar las carpetas vacías en Git y se pueden retirar al añadir contenido.

La navegación y el estado usan herramientas de Flutter: MaterialPageRoute, ChangeNotifier e InheritedNotifier. Se añadió flutter_localizations del SDK para los controles en español. `providers/` reserva el espacio para el estado sin imponer una biblioteca. Inicio está vacío y el catálogo se abre desde Productos.

## Recursos

Las ilustraciones originales de productos están registradas en pubspec.yaml y su procedencia se explica en assets/images/README.md. Registrar los recursos adicionales al incorporarlos. Las fuentes necesitan declarar su familia y sus archivos en `flutter.fonts`.

## Validación

```sh
flutter analyze
flutter test
```


## Demo de ecommerce

- Inicio vacío; búsqueda y filtros en Productos, con favoritos desde el perfil.
- Detalle con ilustración, descripción, especificaciones, valoración de ejemplo y cantidades limitadas al stock de demostración.
- Carrito con cantidades editables, eliminación, subtotal, envío y total. Los importes se calculan con enteros en céntimos; envío S/ 15 por debajo de S/ 299 y gratuito desde ese importe.
- Estado compartido por la sesión en `app/store/`. La lógica del carrito está en `features/cart/domain/`, y el repositorio de catálogo de ejemplo en `features/products/data/` implementa el contrato de dominio.
- Ilustraciones locales sin acceso a red, con alternativa cuando una imagen falla.
- Interfaz clara en español, con áreas seguras, controles táctiles de 48 dp y rejilla que se convierte en una columna con texto grande.

El diseño toma como referencia las imágenes aportadas: rojo coral, superficies claras y tarjetas redondeadas. Se usaron las referencias de UI/UX Pro Max y sus datos locales de ecommerce/Flutter. El buscador Python del skill no pudo ejecutarse porque Python no está disponible; se consultaron manualmente sus guías y datos. No se presenta esa consulta manual como un sistema generado por el script.

`design-review/` contiene capturas de revisión en un viewport de 390 × 844, renderizadas al doble de resolución con las fuentes del SDK.

Pendiente para producción: servidor de la tienda, catálogo e inventario compartidos, autenticación real, tarifas de envío reales, pagos y notificaciones push. La compra actual crea pedidos locales persistentes, sin enviar pedidos a una tienda ni realizar cobros. Los estados pueden actualizarse desde ShopController.updateOrderStatus; no se simulan entregas ni se cambian estados por temporizadores. Los temas claro y oscuro están disponibles.

## Compra local, direcciones, pedidos y reseñas

- El carrito exige seleccionar una dirección y muestra esa sección antes de los productos. Permite crear direcciones desde el carrito o desde Mis direcciones, con departamento, provincia, distrito y dirección. Se pueden editar y eliminar; los pedidos históricos conservan su copia original.
- «Realizar compra» guarda un pedido con identificador único, cantidades, precios confirmados, costo de envío y dirección; después vacía el carrito y abre Mis pedidos. La confirmación bloquea compras repetidas mientras guarda. Si falla el guardado, conserva el carrito para reintentar.
- Mis pedidos y la pestaña Pedidos abren la misma lista. El detalle incluye productos, dirección, subtotal, envío, total y seguimiento con fechas de las actualizaciones recibidas.
- Notificaciones guarda la confirmación y cada avance de estado (recibido, preparación, listo para enviar, en camino y entregado). Los avisos abren el pedido y se pueden marcar como leídos. No son notificaciones push ni cambios de estado automáticos.
- Desde cada producto se puede escribir una reseña de una a cinco estrellas. Mis reseñas lista únicamente las escritas en este dispositivo y permite abrir el producto, editar o eliminar la reseña.
- `CustomerAccountRepository` separa el estado de la cuenta de su almacenamiento. En la aplicación iniciada desde `main.dart`, `app/data/preferences_customer_account_repository.dart` guarda una instantánea JSON mediante [shared_preferences](https://pub.dev/packages/shared_preferences). Las pruebas y las instancias de `CibermaxApp` sin repositorio explícito usan almacenamiento en memoria. Es una implementación local del catálogo de ejemplo; para pedidos comerciales y consistencia entre dispositivos debe sustituirse por el servidor de la tienda.
- Las pruebas cubren creación y recuperación de pedidos, bloqueo de duplicados, fallos al guardar, copias históricas de direcciones/precios, reserva de stock local, cambios de estado sin avisos duplicados, edición de reseñas y pantallas con texto ampliado en tema claro/oscuro.

## Sesión visual

La app arranca sin sesión. El menú ofrece «Continuar con Google» para activar la identidad de Jack Perez y las secciones de la referencia. `ProfilePage` conserva también la vista de bienvenida para `isSignedIn: false`. Este parámetro es de presentación; todavía no representa una sesión de autenticación real.

En la maqueta, «Continuar con Google» activa el menú de Jack. `HomePage` conserva esta selección visual al abrir/cerrar el menú y visitar el perfil mientras siga montado; al reiniciar la app vuelve a mostrarse la vista sin sesión. Esta transición no realiza autenticación con Google ni guarda credenciales. La flecha superior y «Seguir explorando» regresan al Inicio.

«Cerrar sesión», al final del menú de cuenta, desactiva la sesión visual mediante `onSignOut` y regresa a la bienvenida de Perfil.

## Pantalla de arranque

- `features/splash/presentation/pages/splash_page.dart`: fondo #F6F9FA tomado de los bordes de la imagen y márgenes suavizados, logo original, fade in, escala de 0.94 a 1 y desplazamiento vertical de solo 2.5 % de la altura del logo, seguido de fade out. Se libera el AnimationController en dispose y se evita navegar tras desmontar el widget.
- Duración Flutter configurada: 400 ms de animación + 100 ms de entrada al inicio = 500 milisegundos. El tiempo de arranque del sistema operativo es adicional y depende del dispositivo.
- La ruta inicial `/` se reemplaza por `/home`, por lo que Atrás no regresa al splash. No hay autenticación conectada en el proyecto actual.
- Con movimiento reducido se muestra el logo estático y se mantiene la navegación automática.
- Android: LaunchTheme y NormalTheme en #F6F9FA en modo claro y oscuro, imagen centrada antes de Android 12 y recurso compatible con la máscara del splash del sistema desde API 31.
- iOS: LaunchScreen.storyboard en #F6F9FA con LaunchImage centrado, aspect fit y restricciones de tamaño para móvil y tableta.
- No se añadieron dependencias. Los recursos nativos se configuraron manualmente siguiendo la documentación de Flutter: https://docs.flutter.dev/platform-integration/android/splash-screen y Android: https://developer.android.com/develop/ui/views/launch/splash-screen

Para revisar el splash nativo, detener la app completamente y abrirla desde el lanzador; hot reload no actualiza el arranque nativo. La validación de iOS requiere macOS y Xcode.
