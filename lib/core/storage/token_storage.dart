import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_access_token';
  static const String _localUsersKey = 'local_registered_users';

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

  Future<bool> saveLocalRegisteredUser({
    required int id,
    required String username,
    required String password,
  }) async {
    final users = _readLocalUsers();
    users[username.trim()] = {
      'id': id,
      'password': password.trim(),
    };
    return _preferences.setString(_localUsersKey, jsonEncode(users));
  }

  ({int id, String username})? findLocalRegisteredUser({
    required String username,
    required String password,
  }) {
    final users = _readLocalUsers();
    final entry = users[username.trim()];
    if (entry is! Map) {
      return null;
    }

    if (entry['password'] != password.trim()) {
      return null;
    }

    final id = entry['id'];
    if (id is! num) {
      return null;
    }

    return (id: id.toInt(), username: username.trim());
  }

  Map<String, dynamic> _readLocalUsers() {
    final raw = _preferences.getString(_localUsersKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    return {};
  }
}
