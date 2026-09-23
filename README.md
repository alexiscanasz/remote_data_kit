# remote_data_kit

Cliente HTTP reutilizable sobre [Dio](https://pub.dev/packages/dio), con manejo
de resultados tipo `Result<T>` (`Success` / `Failure`), clasificación simple de
errores y adaptadores para castear respuestas JSON de forma segura.

No conoce ningún dominio específico: tú le dices, mediante un `mapper`, cómo
convertir el JSON crudo en tus propios modelos.

## Instalación

```yaml
dependencies:
  remote_data_kit:
    git:
      url: https://github.com/alexiscanasz/remote_data_kit
```

## Uso básico

```dart
import 'package:dio/dio.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

final client = DioGetClient(Dio());

final result = await client.get<List<Product>>(
  'https://fakestoreapi.com/products',
  mapper: (data) => asJsonList(data)
      .map((json) => Product.fromJson(json))
      .toList(),
);

switch (result) {
  case Success<List<Product>>(:final value):
    print('Productos: $value');
  case Failure<List<Product>>(:final message, :final type):
    print('Error ($type): $message');
}
```

## Manejo de errores

`Failure<T>` incluye un `FailureType` para distinguir el origen del error:

- `FailureType.network` — sin conexión, timeout.
- `FailureType.server` — el servidor respondió con error (4xx/5xx).
- `FailureType.unknown` — cualquier otro caso, incluyendo errores de mapeo.

## Adaptadores JSON

`asJsonMap` y `asJsonList` castean la respuesta cruda a `Map<String, dynamic>`
o `List<Map<String, dynamic>>`, lanzando un `FormatException` con mensaje claro
si la forma del dato no coincide.

## Ejemplo completo

Ver [`example/`](./example) — una app Flutter que consume
[Fake Store API](https://fakestoreapi.com) usando este paquete.

```bash
cd example
flutter run
```

## Demostración

Video mostrando el `example` en funcionamiento: 