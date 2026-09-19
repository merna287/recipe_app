import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/features/auth/data/models/register_response_model.dart';

void main() {
  test('RegisterResponseModel.fromJson maps DummyJSON /users/add response', () {
    const json = {
      'id': 209,
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'testuser999@dummyjson.com',
      'username': 'testuser999',
      'password': 'password123',
      'role': 'user',
    };

    final model = RegisterResponseModel.fromJson(json);

    expect(model.id, 209);
    expect(model.firstName, 'Test');
    expect(model.lastName, 'User');
    expect(model.email, 'testuser999@dummyjson.com');
    expect(model.username, 'testuser999');
  });
}
