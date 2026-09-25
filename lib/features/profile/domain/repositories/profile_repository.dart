import '../entities/user_profile.dart';

/// Domain contract for managing user profile retrieval and cache.
abstract class ProfileRepository {
  /// Fetches the profile of the current authenticated user.
  Future<UserProfile> getProfile();

  /// Clears any cached profile data.
  Future<void> clearCachedProfile();
}
