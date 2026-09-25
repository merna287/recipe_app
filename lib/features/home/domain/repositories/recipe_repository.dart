import '../entities/recipe.dart';

/// Domain contract for recipe operations.
/// Defines business capabilities for fetching and searching recipes
/// without exposing data layer details.
abstract class RecipeRepository {
  /// Fetches a list of recipes from data layer.
  Future<List<Recipe>> getRecipes();

  /// Searches recipes by keyword.
  Future<List<Recipe>> searchRecipes(String query);
}
