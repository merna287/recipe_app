class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String meEndpoint = '/auth/me';
  static const String recipesEndpoint = '/recipes';

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
