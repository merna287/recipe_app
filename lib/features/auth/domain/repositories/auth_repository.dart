import '../entities/auth_session.dart';

/// Domain contract for authentication operations.
/// Defines what the app can do regarding authentication without specifying how.
abstract class AuthRepository {
  /// Authenticates user against backend API, stores token, and returns [AuthSession].
  /// Throws domain [Failure] if login or storage fails.
  Future<AuthSession> login({
    required String username,
    required String password,
  });
}
