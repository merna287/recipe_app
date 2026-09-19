import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

/// Interceptor that automatically attaches the Bearer token
/// to outbound requests when available, and handles 401 Unauthorized responses.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the request explicitly asks to skip authentication
    final requiresAuth = options.extra['requiresAuth'] ?? true;

    if (requiresAuth) {
      final token = _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If the server returns 401 Unauthorized, the stored token is invalid or expired
    if (err.response?.statusCode == 401) {
      _tokenStorage.clearToken();
    }
    return handler.next(err);
  }
}
