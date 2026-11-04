# Cibermax Móvil

Aplicación Flutter organizada por funcionalidades, con separación de presentación, dominio y datos.

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

La navegación y el estado usan herramientas de Flutter: MaterialPageRoute, ChangeNotifier e InheritedNotifier. Se añadió flutter_localizations del SDK para los controles en español. `providers/` reserva el espacio para el estado sin imponer una biblioteca. El inicio muestra el catálogo de demostración de Cibermax.

## Recursos

Las ilustraciones originales de productos están registradas en pubspec.yaml y su procedencia se explica en assets/images/README.md. Registrar los recursos adicionales al incorporarlos. Las fuentes necesitan declarar su familia y sus archivos en `flutter.fonts`.

## Validación

```sh
flutter analyze
flutter test
```


## Demo de ecommerce

- Inicio con búsqueda por nombre/categoría, filtros, banner de audio y favoritos.
- Detalle con ilustración, descripción, especificaciones, valoración de ejemplo y cantidades limitadas al stock de demostración.
- Carrito con cantidades editables, eliminación, subtotal, envío y total. Los importes se calculan con enteros en céntimos; envío S/ 15 por debajo de S/ 299 y gratuito desde ese importe.
- Estado compartido por la sesión en `app/store/`. La lógica del carrito está en `features/cart/domain/`, y el repositorio de catálogo de ejemplo en `features/products/data/` implementa el contrato de dominio.
- Ilustraciones locales sin acceso a red, con alternativa cuando una imagen falla.
- Interfaz clara en español, con áreas seguras, controles táctiles de 48 dp y rejilla que se convierte en una columna con texto grande.

El diseño toma como referencia las imágenes aportadas: verde oscuro, naranja, superficies claras y tarjetas redondeadas. Se usaron las referencias de UI/UX Pro Max y sus datos locales de ecommerce/Flutter. El buscador Python del skill no pudo ejecutarse porque Python no está disponible; se consultaron manualmente sus guías y datos. No se presenta esa consulta manual como un sistema generado por el script.

`design-review/` contiene capturas de revisión en un viewport de 390 × 844, renderizadas al doble de resolución con las fuentes del SDK.

Pendiente para producción: API y catálogo real, fotografías comerciales, autenticación, direcciones, cálculo real de envíos, persistencia después de cerrar la app y pagos. Continuar compra muestra una explicación de la demo; no crea pedidos ni realiza cobros. La ubicación es una referencia fija y las valoraciones son ficticias. Por ahora se ofrece un tema claro.

## Pantalla de arranque

- `features/splash/presentation/pages/splash_page.dart`: fondo #F6F9FA tomado de los bordes de la imagen y márgenes suavizados, logo original, fade in, escala de 0.94 a 1 y desplazamiento vertical de solo 2.5 % de la altura del logo, seguido de fade out. Se libera el AnimationController en dispose y se evita navegar tras desmontar el widget.
- Duración Flutter configurada: 400 ms de animación + 100 ms de entrada al inicio = 500 milisegundos. El tiempo de arranque del sistema operativo es adicional y depende del dispositivo.
- La ruta inicial `/` se reemplaza por `/home`, por lo que Atrás no regresa al splash. No hay autenticación conectada en el proyecto actual.
- Con movimiento reducido se muestra el logo estático y se mantiene la navegación automática.
- Android: LaunchTheme y NormalTheme en #F6F9FA en modo claro y oscuro, imagen centrada antes de Android 12 y recurso compatible con la máscara del splash del sistema desde API 31.
- iOS: LaunchScreen.storyboard en #F6F9FA con LaunchImage centrado, aspect fit y restricciones de tamaño para móvil y tableta.
- No se añadieron dependencias. Los recursos nativos se configuraron manualmente siguiendo la documentación de Flutter: https://docs.flutter.dev/platform-integration/android/splash-screen y Android: https://developer.android.com/develop/ui/views/launch/splash-screen

Para revisar el splash nativo, detener la app completamente y abrirla desde el lanzador; hot reload no actualiza el arranque nativo. La validación de iOS requiere macOS y Xcode.


