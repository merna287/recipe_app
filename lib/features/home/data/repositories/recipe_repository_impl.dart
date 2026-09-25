import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../models/recipe_model.dart';

/// Concrete implementation of [RecipeRepository].
/// Coordinates remote data source requests with fallback sample data
/// to guarantee offline resilience and clean domain mappings.
class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _remoteDataSource;

  RecipeRepositoryImpl({
    required RecipeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      final models = await _remoteDataSource.getRecipes();
      if (models.isNotEmpty) {
        return models.map((m) => m.toEntity()).toList();
      }
      return _fallbackEntities;
    } on ServerException {
      return _fallbackEntities;
    } on NetworkException {
      return _fallbackEntities;
    } catch (e) {
      return _fallbackEntities;
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    try {
      final models = await _remoteDataSource.searchRecipes(cleanQuery);
      if (models.isNotEmpty) {
        return models.map((m) => m.toEntity()).toList();
      }
      return _filterFallback(cleanQuery);
    } on Failure {
      return _filterFallback(cleanQuery);
    } catch (_) {
      return _filterFallback(cleanQuery);
    }
  }

  List<Recipe> get _fallbackEntities =>
      RecipeModel.fallbackSampleRecipes.map((m) => m.toEntity()).toList();

  List<Recipe> _filterFallback(String query) {
    if (query.isEmpty) return _fallbackEntities;
    return _fallbackEntities.where((r) {
      return r.name.toLowerCase().contains(query) ||
          r.cuisine.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query);
    }).toList();
  }
}
