import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Single-responsibility use case for user authentication.
/// Encapsulates the specific business rule: authenticating credentials and obtaining a session.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthSession> call({
    required String username,
    required String password,
  }) {
    return _repository.login(
      username: username,
      password: password,
    );
  }
}
