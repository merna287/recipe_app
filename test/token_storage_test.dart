import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('findLocalRegisteredUser returns saved user', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);

    await storage.saveLocalRegisteredUser(
      id: 42,
      username: 'localuser',
      password: 'pass123',
    );

    final match = storage.findLocalRegisteredUser(
      username: 'localuser',
      password: 'pass123',
    );

    expect(match?.id, 42);
    expect(match?.username, 'localuser');
    expect(
      storage.findLocalRegisteredUser(
        username: 'localuser',
        password: 'wrong',
      ),
      isNull,
    );
  });

  test('saveUser and getUser persist and retrieve user correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);

    await storage.saveUser({
      'id': 1,
      'username': 'emilys',
      'email': 'emily@example.com',
    });

    final user = storage.getUser();
    expect(user?['id'], 1);
    expect(user?['username'], 'emilys');
    expect(user?['email'], 'emily@example.com');

    await storage.clear();
    expect(storage.getUser(), isNull);
    expect(storage.getToken(), isNull);
  });

  test('getUser recovers user by local token when session is not directly cached', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);

    await storage.saveLocalRegisteredUser(
      id: 101,
      username: 'alice',
      password: 'pw',
      email: 'alice@example.com',
      firstName: 'Alice',
      lastName: 'Wonder',
    );
    await storage.saveToken('local-101');

    final user = storage.getUser();
    expect(user?['id'], 101);
    expect(user?['username'], 'alice');
    expect(user?['email'], 'alice@example.com');
    expect(user?['firstName'], 'Alice');
  });
}
