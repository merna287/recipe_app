import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';

/// Contract for persisting and retrieving user profile from local cache.
abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getLastProfile();
  Future<bool> saveProfile(UserProfileModel model);
  Future<bool> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _cachedProfileKey = 'cached_user_profile';
  final SharedPreferences _preferences;

  ProfileLocalDataSourceImpl(this._preferences);

  @override
  Future<UserProfileModel?> getLastProfile() async {
    final raw = _preferences.getString(_cachedProfileKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is Map<String, dynamic>) {
        return UserProfileModel.fromJson(json);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<bool> saveProfile(UserProfileModel model) async {
    final raw = jsonEncode(model.toJson());
    return await _preferences.setString(_cachedProfileKey, raw);
  }

  @override
  Future<bool> clearProfile() async {
    return await _preferences.remove(_cachedProfileKey);
  }
}
