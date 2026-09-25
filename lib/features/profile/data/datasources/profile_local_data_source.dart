import '../../../../core/storage/token_storage.dart';
import '../models/user_profile_model.dart';

/// Contract for persisting and retrieving user profile from local cache.
abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getLastProfile();
  Future<bool> saveProfile(UserProfileModel model);
  Future<bool> clearProfile();
}

/// Implementation delegating to the project's centralized [TokenStorage].
/// Ensures no duplicate storage or divergent keys exist.
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final TokenStorage _tokenStorage;

  ProfileLocalDataSourceImpl(this._tokenStorage);

  @override
  Future<UserProfileModel?> getLastProfile() async {
    final userMap = _tokenStorage.getUser();
    if (userMap != null) {
      return UserProfileModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<bool> saveProfile(UserProfileModel model) async {
    return await _tokenStorage.saveUser(model.toJson());
  }

  @override
  Future<bool> clearProfile() async {
    return await _tokenStorage.clearUserSession();
  }
}
