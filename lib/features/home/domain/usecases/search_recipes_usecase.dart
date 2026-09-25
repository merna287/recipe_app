import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

/// Single-responsibility use case for searching recipes by query.
class SearchRecipesUseCase {
  final RecipeRepository _repository;

  SearchRecipesUseCase(this._repository);

  Future<List<Recipe>> call(String query) {
    return _repository.searchRecipes(query);
  }
}
