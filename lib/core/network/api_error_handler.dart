import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  final String message;
  final int? status;

  ApiErrorHandler._(this.message, this.status);

  static ApiErrorHandler handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    return ApiErrorHandler._(
      'An unexpected error occurred. Please try again.',
      null,
    );
  }

  static ApiErrorHandler _handleDioException(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiErrorHandler._(
          'Connection timed out. Please check your internet connection and try again.',
          statusCode,
        );

      case DioExceptionType.sendTimeout:
        return ApiErrorHandler._(
          'Send request timed out. Please check your internet connection and try again.',
          statusCode,
        );

      case DioExceptionType.receiveTimeout:
        return ApiErrorHandler._(
          'Server response timed out. Please try again later.',
          statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiErrorHandler._(
          'No internet connection. Please verify your network and try again.',
          statusCode,
        );

      case DioExceptionType.badCertificate:
        return ApiErrorHandler._(
          'Security certificate validation failed. Please check your network security.',
          statusCode,
        );

      case DioExceptionType.cancel:
        return ApiErrorHandler._(
          'Request was cancelled.',
          statusCode,
        );

      case DioExceptionType.transformTimeout:
        return ApiErrorHandler._(
          'Request data transformation timed out.',
          statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.unknown:
        return ApiErrorHandler._(
          'An unexpected network error occurred. Please try again.',
          statusCode,
        );
    }
  }

  static ApiErrorHandler _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final dynamic data = error.response?.data;

    String? extractedMessage;

    if (data is Map<String, dynamic>) {
      final errorModel = ApiErrorModel.fromJson(data);
      if (errorModel.message != null && errorModel.message!.trim().isNotEmpty) {
        extractedMessage = errorModel.message;
      }
    } else if (data is Map) {
      final safeMap = data.map((key, value) => MapEntry(key.toString(), value));
      final errorModel = ApiErrorModel.fromJson(safeMap);
      if (errorModel.message != null && errorModel.message!.trim().isNotEmpty) {
        extractedMessage = errorModel.message;
      }
    } else if (data is String && data.trim().isNotEmpty) {
      extractedMessage = data.trim();
    }

    final message = extractedMessage ?? _fallbackMessage(statusCode);

    return ApiErrorHandler._(message, statusCode);
  }

  static String _fallbackMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your inputs.';
      case 401:
        return 'Unauthorized. Please check your credentials.';
      case 403:
        return 'Forbidden. You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'A conflict occurred. Please try again.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server returned an error (${statusCode ?? 'unknown'}). Please try again.';
    }
  }

  @override
  String toString() => 'ApiErrorHandler(message: $message, status: $status)';
}
