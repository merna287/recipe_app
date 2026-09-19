/// Thrown by Remote DataSources when an HTTP error or server status code is received.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

/// Thrown when there is no internet connection or a socket timeout occurs.
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Please check your internet connection and try again.',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when reading or writing from local storage fails.
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Failed to access local device storage.',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when authentication credentials or token validation fails.
class AuthException implements Exception {
  final String message;

  const AuthException({
    required this.message,
  });

  @override
  String toString() => 'AuthException: $message';
}
