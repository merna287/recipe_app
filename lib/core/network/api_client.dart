import 'dart:convert';

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'api_error_handler.dart';
import 'auth_interceptor.dart';
import 'dio_config.dart';

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
                sendTimeout: ApiConstants.connectTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    configureDio(_dio);
    _dio.interceptors.add(authInterceptor);
  }

  Dio get dio => _dio;

  static Map<String, dynamic>? parseJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return null;
  }

  static Exception handleError(dynamic error) {
    if (error is ServerException || error is NetworkException) {
      return error;
    }

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
          final apiError = ApiErrorHandler.handle(error);
          return ServerException(
            message: apiError.message,
            statusCode: apiError.status,
          );
        case DioExceptionType.badCertificate:
          return const NetworkException(
            message: 'Security certificate validation failed.',
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

    if (error is String) {
      return ServerException(message: error);
    }

    return ServerException(message: error.toString());
  }
}
