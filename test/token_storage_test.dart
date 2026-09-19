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
}
