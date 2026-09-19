import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'auth_interceptor.dart';

/// Centralized networking client using Dio.
/// Sets up baseUrl, connection timeouts, common headers, and interceptors.
class ApiClient {
  final Dio _dio;

  ApiClient({
    required AuthInterceptor authInterceptor,
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(authInterceptor);
  }

  Dio get dio => _dio;

  /// Helper method to convert DioException to clean domain/data exceptions.
  static Exception handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return const NetworkException(
            message: 'Connection timed out. Please check your internet connection.',
          );
        case DioExceptionType.badResponse:
          final responseData = error.response?.data;
          String errorMessage = 'A server error occurred';
          if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          }
          return ServerException(
            message: errorMessage,
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.cancel:
          return const ServerException(message: 'Request was cancelled.');
        case DioExceptionType.unknown:
        default:
          return const NetworkException(
            message: 'An unexpected network error occurred.',
          );
      }
    }
    return ServerException(message: error.toString());
  }
}
