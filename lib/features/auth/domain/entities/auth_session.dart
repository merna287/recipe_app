import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user session with profile details.
class AuthSession extends Equatable {
  final String token;
  final String username;
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;

  const AuthSession({
    required this.token,
    required this.username,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
  });

  /// Computed display name: full name or username.
  String get fullName {
    final combined = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return combined.isEmpty ? username : combined;
  }

  @override
  List<Object?> get props => [
        token,
        username,
        id,
        email,
        firstName,
        lastName,
        gender,
        image,
      ];
}
