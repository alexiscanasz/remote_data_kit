/// Castea [data] a `Map<String, dynamic>` o lanza un [FormatException]
/// con un mensaje claro si la forma del dato no coincide
Map<String, dynamic> asJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  throw FormatException('Se esperaba un objeto JSON (Map) pero se recibio: ${data.runtimeType}');
}

/// Castea [data] a `List<Map<String, dynamic>>` o lanza un [FormatException]
/// con un mensaje claro si la forma del dato no coincide
List<Map<String, dynamic>> asJsonList(dynamic data) {
  if (data is List) {
    return data.map((item) => asJsonMap(item)).toList();
  }
  throw FormatException('Se esperaba una lista JSON (List) pero se recibio: ${data.runtimeType}');
}
