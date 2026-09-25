import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

/// Business logic component managing the authentication lifecycle.
/// Receives user intents from the UI and coordinates domain use cases.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial());

  /// Attempts to authenticate the user with [username] and [password].
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final session = await _loginUseCase(
        username: username,
        password: password,
      );
      emit(AuthSuccess(session));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final session = await _signUpUseCase(
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
        password: password,
      );
      emit(AuthSuccess(session));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      await _logoutUseCase();
      emit(const AuthUnauthenticated());
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred during logout: ${e.toString()}'));
    }
  }

  /// Resets the cubit back to initial state.
  void reset() {
    emit(const AuthInitial());
  }
}

