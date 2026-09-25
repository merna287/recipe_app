import '../../domain/entities/user_profile.dart';

/// Data transfer model for user profile information from DummyJSON API.
class UserProfileModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String? gender;
  final String? phone;

  const UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.gender,
    this.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      image: json['image'] as String?,
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      if (image != null) 'image': image,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
    };
  }

  /// Maps the technical model into domain entity [UserProfile].
  UserProfile toEntity({
    int cookedRecipesCount = 12,
    int savedRecipesCount = 0,
    int reviewsCount = 24,
  }) {
    return UserProfile(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      image: image,
      gender: gender,
      phone: phone,
      cookedRecipesCount: cookedRecipesCount,
      savedRecipesCount: savedRecipesCount,
      reviewsCount: reviewsCount,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      image: entity.image,
      gender: entity.gender,
      phone: entity.phone,
    );
  }
}
