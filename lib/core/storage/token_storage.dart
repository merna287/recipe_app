import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_access_token';
  static const String _userKey = 'auth_user';
  static const String _localUsersKey = 'local_registered_users';

  final SharedPreferences _preferences;

  TokenStorage(this._preferences);

  Future<bool> saveToken(String token) async {
    return await _preferences.setString(_tokenKey, token);
  }

  String? getToken() {
    return _preferences.getString(_tokenKey);
  }

  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  /// Persists authenticated user data under the unified session key.
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    return await _preferences.setString(_userKey, jsonEncode(userData));
  }

  /// Retrieves the authenticated user data.
  /// If the primary key is not yet set, attempts to resolve from local registered users
  /// if the token indicates an active local session (e.g. 'local-209').
  Map<String, dynamic>? getUser() {
    final raw = _preferences.getString(_userKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    // Resilience fallback: If session key was not populated yet (e.g., created prior to session caching),
    // resolve the user from local registered users using the token ID.
    final token = getToken();
    if (token != null && token.startsWith('local-')) {
      final idStr = token.replaceFirst('local-', '');
      final id = int.tryParse(idStr);
      if (id != null) {
        final localUser = findLocalUserById(id);
        if (localUser != null) {
          final userMap = {
            'id': localUser.id,
            'username': localUser.username,
            'email': localUser.email ?? '${localUser.username}@example.com',
            'firstName': localUser.firstName ?? localUser.username,
            'lastName': localUser.lastName ?? '',
          };
          saveUser(userMap);
          return userMap;
        }
      }
    }

    return null;
  }

  /// Alias for backward compatibility.
  Future<bool> saveUserSession(Map<String, dynamic> userData) => saveUser(userData);

  /// Alias for backward compatibility.
  Map<String, dynamic>? getUserSession() => getUser();

  /// Clears stored user session data.
  Future<bool> clearUserSession() async {
    return await _preferences.remove(_userKey);
  }

  /// Clears session token, user session data, and active saved session items on logout.
  Future<bool> clear() async {
    await clearUserSession();
    await _preferences.remove(_savedRecipesKeyPrefix);
    return await _preferences.remove(_tokenKey);
  }

  Future<bool> clearToken() async {
    return await clear();
  }

  static const String _savedRecipesKeyPrefix = 'saved_recipes_ids';

  /// Saves the user's selected/favorited recipe IDs to local storage.
  Future<bool> saveSavedRecipeIds(Set<int> ids) async {
    final user = getUser();
    final userId = user?['id'];
    final stringList = ids.map((id) => id.toString()).toList();
    if (userId != null) {
      await _preferences.setStringList('${_savedRecipesKeyPrefix}_$userId', stringList);
    }
    return await _preferences.setStringList(_savedRecipesKeyPrefix, stringList);
  }

  /// Retrieves the saved recipe IDs for the active user session.
  Set<int> getSavedRecipeIds() {
    final user = getUser();
    final userId = user?['id'];
    if (userId != null) {
      final userSpecificList = _preferences.getStringList('${_savedRecipesKeyPrefix}_$userId');
      if (userSpecificList != null) {
        return userSpecificList.map((e) => int.tryParse(e)).whereType<int>().toSet();
      }
    }
    final fallbackList = _preferences.getStringList(_savedRecipesKeyPrefix);
    if (fallbackList == null) return {};
    return fallbackList.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Future<bool> saveLocalRegisteredUser({
    required int id,
    required String username,
    required String password,
    String? email,
    String? firstName,
    String? lastName,
  }) async {
    final users = _readLocalUsers();
    users[username.trim()] = {
      'id': id,
      'password': password.trim(),
      if (email != null) 'email': email.trim(),
      if (firstName != null) 'firstName': firstName.trim(),
      if (lastName != null) 'lastName': lastName.trim(),
    };
    return _preferences.setString(_localUsersKey, jsonEncode(users));
  }

  ({
    int id,
    String username,
    String? email,
    String? firstName,
    String? lastName,
  })? findLocalRegisteredUser({
    required String username,
    required String password,
  }) {
    final users = _readLocalUsers();
    final trimmedQuery = username.trim().toLowerCase();

    for (final entry in users.entries) {
      final keyUsername = entry.key.toLowerCase();
      final data = entry.value;
      if (data is! Map) continue;

      final dataEmail = (data['email'] as String?)?.trim().toLowerCase();
      final isMatch = keyUsername == trimmedQuery ||
          (dataEmail != null && dataEmail == trimmedQuery);

      if (isMatch) {
        if (data['password'] != password.trim()) {
          return null;
        }

        final id = data['id'];
        if (id is! num) {
          return null;
        }

        return (
          id: id.toInt(),
          username: entry.key,
          email: data['email'] as String?,
          firstName: data['firstName'] as String?,
          lastName: data['lastName'] as String?,
        );
      }
    }

    return null;
  }

  ({
    int id,
    String username,
    String? email,
    String? firstName,
    String? lastName,
  })? findLocalUserById(int id) {
    final users = _readLocalUsers();
    for (final entry in users.entries) {
      final data = entry.value;
      if (data is Map && data['id'] == id) {
        return (
          id: id,
          username: entry.key,
          email: data['email'] as String?,
          firstName: data['firstName'] as String?,
          lastName: data['lastName'] as String?,
        );
      }
    }
    return null;
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
