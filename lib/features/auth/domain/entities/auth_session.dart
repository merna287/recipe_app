import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user session.
/// Pure business logic representation, independent of network serialization.
class AuthSession extends Equatable {
  final String token;
  final String username;

  const AuthSession({
    required this.token,
    required this.username,
  });

  @override
  List<Object?> get props => [token, username];
}
