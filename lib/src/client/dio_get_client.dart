import 'package:dio/dio.dart';

import '../error/failure_type.dart';
import '../error/result.dart';

final class DioGetClient {
  const DioGetClient(this._dio);

  final Dio _dio;

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) mapper,
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: queryParameters);
      final value = mapper(response.data);
      return Success<T>(value);
    } on DioException catch (exception) {
      return Failure<T>(
        exception.message ?? 'Error al realizar la petición GET.',
        type: _mapFailureType(exception),
      );
    } catch (exception) {
      return Failure<T>(exception.toString());
    }
  }

  FailureType _mapFailureType(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.transformTimeout:
        return FailureType.network;
      case DioExceptionType.badResponse:
        return FailureType.server;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return FailureType.unknown;
    }
  }
}
