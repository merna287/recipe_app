import 'package:equatable/equatable.dart';

/// Domain entity representing a user profile with personal details and foodie stats.
class UserProfile extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String? gender;
  final String? phone;
  final int cookedRecipesCount;
  final int savedRecipesCount;
  final int reviewsCount;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.gender,
    this.phone,
    this.cookedRecipesCount = 12,
    this.savedRecipesCount = 0,
    this.reviewsCount = 24,
  });

  /// Computed display name: returns full name or fallback to username.
  String get fullName {
    final combined = '$firstName $lastName'.trim();
    return combined.isEmpty ? username : combined;
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        image,
        gender,
        phone,
        cookedRecipesCount,
        savedRecipesCount,
        reviewsCount,
      ];
}
