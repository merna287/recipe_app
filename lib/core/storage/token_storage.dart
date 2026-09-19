import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_access_token';

  final SharedPreferences _preferences;

  TokenStorage(this._preferences);

  Future<bool> saveToken(String token) async {
    return await _preferences.setString(_tokenKey, token);
  }

  String? getToken() {
    return _preferences.getString(_tokenKey);
  }

  Future<bool> clearToken() async {
    return await _preferences.remove(_tokenKey);
  }

  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
