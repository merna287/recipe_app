import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_session.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any login attempt is made.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State emitted while the login network request is in flight.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State emitted after credentials have been verified and token persisted.
class AuthSuccess extends AuthState {
  final AuthSession session;

  const AuthSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

/// State emitted when authentication fails (e.g., invalid credentials, network failure).
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
