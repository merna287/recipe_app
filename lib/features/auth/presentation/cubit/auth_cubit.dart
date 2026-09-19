import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

/// Business logic component managing the authentication lifecycle.
/// Receives user intents from the UI and coordinates domain use cases.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
  })  : _loginUseCase = loginUseCase,
        super(const AuthInitial());

  /// Attempts to authenticate the user with [username] and [password].
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Prevent duplicate triggers if a request is already in progress
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

  /// Resets the cubit back to initial state.
  void reset() {
    emit(const AuthInitial());
  }
}
