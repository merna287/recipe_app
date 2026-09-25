import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/features/profile/data/models/user_profile_model.dart';
import 'package:recipe_app/features/profile/domain/entities/user_profile.dart';

void main() {
  const tJson = {
    'id': 1,
    'username': 'emilys',
    'email': 'emily@example.com',
    'firstName': 'Emily',
    'lastName': 'Johnson',
    'image': 'https://dummyjson.com/icon/emilys/128',
    'gender': 'female',
    'phone': '+1 234 567 8900',
  };

  test('UserProfileModel.fromJson parses complete JSON correctly', () {
    final model = UserProfileModel.fromJson(tJson);

    expect(model.id, 1);
    expect(model.username, 'emilys');
    expect(model.email, 'emily@example.com');
    expect(model.firstName, 'Emily');
    expect(model.lastName, 'Johnson');
    expect(model.image, 'https://dummyjson.com/icon/emilys/128');
    expect(model.gender, 'female');
    expect(model.phone, '+1 234 567 8900');
  });

  test('UserProfileModel.toJson serializes model back to Map', () {
    final model = UserProfileModel.fromJson(tJson);
    final json = model.toJson();

    expect(json['id'], 1);
    expect(json['username'], 'emilys');
    expect(json['email'], 'emily@example.com');
    expect(json['firstName'], 'Emily');
    expect(json['lastName'], 'Johnson');
  });

  test('UserProfileModel.toEntity maps into domain UserProfile', () {
    final model = UserProfileModel.fromJson(tJson);
    final entity = model.toEntity(
      cookedRecipesCount: 15,
      savedRecipesCount: 9,
      reviewsCount: 30,
    );

    expect(entity, isA<UserProfile>());
    expect(entity.fullName, 'Emily Johnson');
    expect(entity.cookedRecipesCount, 15);
    expect(entity.savedRecipesCount, 9);
    expect(entity.reviewsCount, 30);
  });
}
