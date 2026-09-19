class RecipeUiModel {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int cookTimeMinutes;
  final String difficulty;
  final String cuisine;
  final int calories;
  final String category;
  final bool isFavorite;

  const RecipeUiModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.cuisine,
    required this.calories,
    required this.category,
    this.isFavorite = false,
  });

  RecipeUiModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? cookTimeMinutes,
    String? difficulty,
    String? cuisine,
    int? calories,
    String? category,
    bool? isFavorite,
  }) {
    return RecipeUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      cuisine: cuisine ?? this.cuisine,
      calories: calories ?? this.calories,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static List<RecipeUiModel> get samplePopularRecipes => const [
        RecipeUiModel(
          id: 1,
          name: 'Classic Creamy Carbonara',
          imageUrl:
              'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=600&q=80',
          rating: 4.9,
          reviewCount: 342,
          cookTimeMinutes: 25,
          difficulty: 'Medium',
          cuisine: 'Italian',
          calories: 520,
          category: 'Pasta',
        ),
        RecipeUiModel(
          id: 2,
          name: 'Pan-Seared Teriyaki Salmon',
          imageUrl:
              'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&q=80',
          rating: 4.8,
          reviewCount: 218,
          cookTimeMinutes: 20,
          difficulty: 'Easy',
          cuisine: 'Japanese',
          calories: 410,
          category: 'Seafood',
        ),
        RecipeUiModel(
          id: 3,
          name: 'Artisan Angus Brioche Burger',
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
          rating: 4.9,
          reviewCount: 489,
          cookTimeMinutes: 30,
          difficulty: 'Medium',
          cuisine: 'American',
          calories: 680,
          category: 'Dinner',
        ),
        RecipeUiModel(
          id: 4,
          name: 'Berry Fluffy Soufflé Pancakes',
          imageUrl:
              'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=600&q=80',
          rating: 4.7,
          reviewCount: 175,
          cookTimeMinutes: 15,
          difficulty: 'Easy',
          cuisine: 'French',
          calories: 340,
          category: 'Breakfast',
        ),
      ];

  static List<RecipeUiModel> get sampleRecommendedRecipes => const [
        RecipeUiModel(
          id: 5,
          name: 'Mediterranean Avocado Bowl',
          imageUrl:
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
          rating: 4.8,
          reviewCount: 194,
          cookTimeMinutes: 15,
          difficulty: 'Easy',
          cuisine: 'Greek',
          calories: 290,
          category: 'Healthy',
        ),
        RecipeUiModel(
          id: 6,
          name: 'Wood-Fired Margherita Pizza',
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=80',
          rating: 4.9,
          reviewCount: 520,
          cookTimeMinutes: 35,
          difficulty: 'Hard',
          cuisine: 'Italian',
          calories: 590,
          category: 'Dinner',
        ),
        RecipeUiModel(
          id: 7,
          name: 'Authentic Tonkotsu Ramen',
          imageUrl:
              'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&q=80',
          rating: 4.9,
          reviewCount: 310,
          cookTimeMinutes: 45,
          difficulty: 'Medium',
          cuisine: 'Japanese',
          calories: 540,
          category: 'Lunch',
        ),
        RecipeUiModel(
          id: 8,
          name: 'Garlic Butter Ribeye Steak',
          imageUrl:
              'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
          rating: 4.9,
          reviewCount: 422,
          cookTimeMinutes: 25,
          difficulty: 'Medium',
          cuisine: 'Continental',
          calories: 650,
          category: 'Dinner',
        ),
      ];
}
