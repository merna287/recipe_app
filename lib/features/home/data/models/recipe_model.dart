import '../../domain/entities/recipe.dart';

/// Data transfer model representing a recipe item from the DummyJSON API.
class RecipeModel {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final List<String> tags;
  final int userId;
  final String image;
  final double rating;
  final int reviewCount;
  final List<String> mealType;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.userId,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? 'Recipe',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt() ?? 15,
      cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt() ?? 20,
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      difficulty: (json['difficulty'] as String?) ?? 'Medium',
      cuisine: (json['cuisine'] as String?) ?? 'International',
      caloriesPerServing:
          (json['caloriesPerServing'] as num?)?.toInt() ?? 350,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      image: (json['image'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 100,
      mealType: (json['mealType'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'caloriesPerServing': caloriesPerServing,
      'tags': tags,
      'userId': userId,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'mealType': mealType,
    };
  }

  /// Derives primary category from mealType or tags, defaulting to 'Dinner'.
  String get primaryCategory {
    if (mealType.isNotEmpty) {
      final firstType = mealType.first;
      if (firstType.toLowerCase() == 'snack' ||
          firstType.toLowerCase() == 'dessert') {
        return 'Healthy';
      }
      return firstType;
    }
    if (tags.isNotEmpty) {
      return tags.first;
    }
    return 'Dinner';
  }

  /// Converts this DTO model into clean domain [Recipe] entity.
  Recipe toEntity({bool isFavorite = false}) {
    return Recipe(
      id: id,
      name: name,
      imageUrl: image,
      rating: rating,
      reviewCount: reviewCount,
      cookTimeMinutes: cookTimeMinutes + prepTimeMinutes,
      difficulty: difficulty,
      cuisine: cuisine,
      calories: caloriesPerServing,
      category: primaryCategory,
      isFavorite: isFavorite,
      ingredients: ingredients,
      instructions: instructions,
    );
  }

  /// Built-in fallback sample models used when device is offline
  static List<RecipeModel> get fallbackSampleRecipes => const [
        RecipeModel(
          id: 1,
          name: 'Classic Creamy Carbonara',
          ingredients: ['Spaghetti', 'Eggs', 'Pancetta', 'Pecorino Romano'],
          instructions: ['Boil pasta', 'Fry pancetta', 'Whisk eggs', 'Combine'],
          prepTimeMinutes: 10,
          cookTimeMinutes: 15,
          servings: 2,
          difficulty: 'Medium',
          cuisine: 'Italian',
          caloriesPerServing: 520,
          tags: ['Pasta', 'Italian'],
          userId: 1,
          image:
              'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=600&q=80',
          rating: 4.9,
          reviewCount: 342,
          mealType: ['Pasta', 'Dinner'],
        ),
        RecipeModel(
          id: 2,
          name: 'Pan-Seared Teriyaki Salmon',
          ingredients: ['Salmon fillets', 'Teriyaki sauce', 'Sesame seeds'],
          instructions: ['Marinate salmon', 'Sear in skillet', 'Garnish'],
          prepTimeMinutes: 5,
          cookTimeMinutes: 15,
          servings: 2,
          difficulty: 'Easy',
          cuisine: 'Japanese',
          caloriesPerServing: 410,
          tags: ['Seafood', 'Japanese'],
          userId: 2,
          image:
              'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&q=80',
          rating: 4.8,
          reviewCount: 218,
          mealType: ['Seafood', 'Dinner'],
        ),
        RecipeModel(
          id: 3,
          name: 'Artisan Angus Brioche Burger',
          ingredients: ['Angus beef', 'Brioche bun', 'Cheddar', 'Caramelized onion'],
          instructions: ['Form patties', 'Grill patties', 'Assemble burgers'],
          prepTimeMinutes: 10,
          cookTimeMinutes: 20,
          servings: 2,
          difficulty: 'Medium',
          cuisine: 'American',
          caloriesPerServing: 680,
          tags: ['Burger', 'Dinner'],
          userId: 3,
          image:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
          rating: 4.9,
          reviewCount: 489,
          mealType: ['Dinner', 'Lunch'],
        ),
        RecipeModel(
          id: 4,
          name: 'Berry Fluffy Soufflé Pancakes',
          ingredients: ['Flour', 'Eggs', 'Milk', 'Fresh berries', 'Maple syrup'],
          instructions: ['Separate whites', 'Beat meringue', 'Fold and cook'],
          prepTimeMinutes: 5,
          cookTimeMinutes: 10,
          servings: 2,
          difficulty: 'Easy',
          cuisine: 'French',
          caloriesPerServing: 340,
          tags: ['Breakfast', 'Sweet'],
          userId: 4,
          image:
              'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=600&q=80',
          rating: 4.7,
          reviewCount: 175,
          mealType: ['Breakfast'],
        ),
        RecipeModel(
          id: 5,
          name: 'Mediterranean Avocado Bowl',
          ingredients: ['Avocado', 'Quinoa', 'Cucumber', 'Kalamata olives', 'Feta'],
          instructions: ['Cook quinoa', 'Dice ingredients', 'Toss with vinaigrette'],
          prepTimeMinutes: 10,
          cookTimeMinutes: 5,
          servings: 1,
          difficulty: 'Easy',
          cuisine: 'Greek',
          caloriesPerServing: 290,
          tags: ['Healthy', 'Salad'],
          userId: 5,
          image:
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
          rating: 4.8,
          reviewCount: 194,
          mealType: ['Healthy', 'Lunch'],
        ),
        RecipeModel(
          id: 6,
          name: 'Wood-Fired Margherita Pizza',
          ingredients: ['Pizza dough', 'San Marzano tomatoes', 'Fresh mozzarella', 'Basil'],
          instructions: ['Stretch dough', 'Spread sauce and cheese', 'Bake at max temp'],
          prepTimeMinutes: 15,
          cookTimeMinutes: 20,
          servings: 3,
          difficulty: 'Hard',
          cuisine: 'Italian',
          caloriesPerServing: 590,
          tags: ['Pizza', 'Italian'],
          userId: 6,
          image:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=80',
          rating: 4.9,
          reviewCount: 520,
          mealType: ['Dinner'],
        ),
        RecipeModel(
          id: 7,
          name: 'Authentic Tonkotsu Ramen',
          ingredients: ['Ramen noodles', 'Pork broth', 'Chashu', 'Ajitsuke tamago'],
          instructions: ['Simmer broth', 'Boil noodles', 'Assemble bowl'],
          prepTimeMinutes: 15,
          cookTimeMinutes: 30,
          servings: 2,
          difficulty: 'Medium',
          cuisine: 'Japanese',
          caloriesPerServing: 540,
          tags: ['Ramen', 'Japanese'],
          userId: 7,
          image:
              'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&q=80',
          rating: 4.9,
          reviewCount: 310,
          mealType: ['Lunch', 'Dinner'],
        ),
        RecipeModel(
          id: 8,
          name: 'Garlic Butter Ribeye Steak',
          ingredients: ['Ribeye steak', 'Butter', 'Garlic', 'Rosemary', 'Thyme'],
          instructions: ['Season steak', 'Sear in hot cast iron', 'Baste with garlic butter'],
          prepTimeMinutes: 5,
          cookTimeMinutes: 20,
          servings: 2,
          difficulty: 'Medium',
          cuisine: 'Continental',
          caloriesPerServing: 650,
          tags: ['Steak', 'Meat'],
          userId: 8,
          image:
              'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
          rating: 4.9,
          reviewCount: 422,
          mealType: ['Dinner'],
        ),
      ];
}
