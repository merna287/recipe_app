import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

/// Single-responsibility use case for retrieving recipes.
class GetRecipesUseCase {
  final RecipeRepository _repository;

  GetRecipesUseCase(this._repository);

  Future<List<Recipe>> call() {
    return _repository.getRecipes();
  }
}
