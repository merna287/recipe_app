import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the business rule for creating a new user account.
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthSession> call({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) {
    return _repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
    );
  }
}
