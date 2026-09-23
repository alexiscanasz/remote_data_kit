/// Clasificacion simple del origen de un [Failure]
enum FailureType {
  /// No hay conexion, timeout, host inaccesible, etc
  network,

  /// El servidor respondio con un error (4xx, 5xx)
  server,

  /// Cualquier otro caso no clasificado
  unknown,
}
