import '../../domain/entities/recipe.dart';
import 'recipe_model.dart';

/// Legacy UI model bridge extending the domain [Recipe] entity.
/// Preserved for backwards compatibility while Clean Architecture domain models are adopted.
class RecipeUiModel extends Recipe {
  const RecipeUiModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.cookTimeMinutes,
    required super.difficulty,
    required super.cuisine,
    required super.calories,
    required super.category,
    super.isFavorite = false,
    super.ingredients = const [],
    super.instructions = const [],
  });

  static List<RecipeUiModel> get samplePopularRecipes => RecipeModel
      .fallbackSampleRecipes
      .take(4)
      .map((m) {
        final e = m.toEntity();
        return RecipeUiModel(
          id: e.id,
          name: e.name,
          imageUrl: e.imageUrl,
          rating: e.rating,
          reviewCount: e.reviewCount,
          cookTimeMinutes: e.cookTimeMinutes,
          difficulty: e.difficulty,
          cuisine: e.cuisine,
          calories: e.calories,
          category: e.category,
          isFavorite: e.isFavorite,
        );
      })
      .toList();

  static List<RecipeUiModel> get sampleRecommendedRecipes => RecipeModel
      .fallbackSampleRecipes
      .skip(4)
      .map((m) {
        final e = m.toEntity();
        return RecipeUiModel(
          id: e.id,
          name: e.name,
          imageUrl: e.imageUrl,
          rating: e.rating,
          reviewCount: e.reviewCount,
          cookTimeMinutes: e.cookTimeMinutes,
          difficulty: e.difficulty,
          cuisine: e.cuisine,
          calories: e.calories,
          category: e.category,
          isFavorite: e.isFavorite,
        );
      })
      .toList();
}
