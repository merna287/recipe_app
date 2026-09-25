import '../repositories/auth_repository.dart';

/// Domain use case for terminating user session and clearing credentials.
class LogoutUseCase {
  final AuthRepository _authRepository;

  const LogoutUseCase(this._authRepository);

  Future<void> call() async {
    return await _authRepository.logout();
  }
}
