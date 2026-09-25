import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/features/home/data/models/recipe_model.dart';

void main() {
  group('RecipeModel', () {
    test('fromJson correctly parses DummyJSON recipe format', () {
      final json = {
        'id': 1,
        'name': 'Classic Margherita Pizza',
        'ingredients': ['Pizza dough', 'San Marzano tomatoes', 'Fresh mozzarella', 'Basil'],
        'instructions': ['Stretch dough', 'Top with ingredients', 'Bake'],
        'prepTimeMinutes': 20,
        'cookTimeMinutes': 15,
        'servings': 4,
        'difficulty': 'Easy',
        'cuisine': 'Italian',
        'caloriesPerServing': 300,
        'tags': ['Pizza', 'Italian'],
        'userId': 45,
        'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
        'rating': 4.6,
        'reviewCount': 98,
        'mealType': ['Dinner'],
      };

      final model = RecipeModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'Classic Margherita Pizza');
      expect(model.cuisine, 'Italian');
      expect(model.primaryCategory, 'Dinner');
      expect(model.caloriesPerServing, 300);

      final entity = model.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'Classic Margherita Pizza');
      expect(entity.category, 'Dinner');
      expect(entity.cookTimeMinutes, 35); // 20 + 15
      expect(entity.isFavorite, isFalse);
    });

    test('toEntity preserves favorite state', () {
      const model = RecipeModel(
        id: 10,
        name: 'Avocado Toast',
        ingredients: ['Bread', 'Avocado'],
        instructions: ['Toast', 'Spread'],
        prepTimeMinutes: 5,
        cookTimeMinutes: 5,
        servings: 1,
        difficulty: 'Easy',
        cuisine: 'American',
        caloriesPerServing: 200,
        tags: ['Healthy'],
        userId: 1,
        image: 'https://example.com/toast.png',
        rating: 4.8,
        reviewCount: 50,
        mealType: ['Breakfast'],
      );

      final entity = model.toEntity(isFavorite: true);
      expect(entity.isFavorite, isTrue);
      expect(entity.category, 'Breakfast');
    });
  });
}
