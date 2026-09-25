import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/usecases/get_recipes_usecase.dart';
import '../../domain/usecases/search_recipes_usecase.dart';
import 'home_state.dart';

/// Business logic component managing home state, recipe retrieval,
/// filtering by category, search queries, and bookmark favorites.
class HomeCubit extends Cubit<HomeState> {
  final GetRecipesUseCase _getRecipesUseCase;
  final SearchRecipesUseCase _searchRecipesUseCase;
  final TokenStorage _tokenStorage;

  HomeCubit({
    required GetRecipesUseCase getRecipesUseCase,
    required SearchRecipesUseCase searchRecipesUseCase,
    required TokenStorage tokenStorage,
  })  : _getRecipesUseCase = getRecipesUseCase,
        _searchRecipesUseCase = searchRecipesUseCase,
        _tokenStorage = tokenStorage,
        super(const HomeInitial());

  Future<void> loadRecipes() async {
    emit(const HomeLoading());
    try {
      final recipes = await _getRecipesUseCase();
      final savedIds = _tokenStorage.getSavedRecipeIds();

      final updatedAll = recipes.map((r) {
        return r.copyWith(isFavorite: savedIds.contains(r.id));
      }).toList();

      final popular = updatedAll.take(4).toList();
      final recommended = updatedAll.skip(4).toList();

      emit(HomeLoaded(
        popularRecipes: popular,
        recommendedRecipes:
            recommended.isNotEmpty ? recommended : updatedAll,
        allRecipes: updatedAll,
        favoriteRecipeIds: savedIds,
      ));
    } catch (e) {
      emit(HomeError('Failed to load recipes: ${e.toString()}'));
    }
  }

  void selectCategory(String category) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(selectedCategory: category));
    }
  }

  Future<void> search(String query) async {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(current.copyWith(searchQuery: query));

    final trimmed = query.trim();
    if (trimmed.length >= 2) {
      try {
        final remoteMatches = await _searchRecipesUseCase(trimmed);
        if (state is HomeLoaded && remoteMatches.isNotEmpty) {
          final updated = state as HomeLoaded;
          final existingIds = updated.allRecipes.map((r) => r.id).toSet();
          final newRecipes = remoteMatches
              .where((r) => !existingIds.contains(r.id))
              .map((r) => r.copyWith(
                    isFavorite: updated.favoriteRecipeIds.contains(r.id),
                  ))
              .toList();

          if (newRecipes.isNotEmpty) {
            emit(updated.copyWith(
              allRecipes: [...updated.allRecipes, ...newRecipes],
            ));
          }
        }
      } catch (_) {
        // Local filtering operates seamlessly if offline
      }
    }
  }

  void resetFilters() {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(selectedCategory: 'All', searchQuery: ''));
    }
  }

  void toggleFavorite(int recipeId) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final updatedFavorites = Set<int>.from(current.favoriteRecipeIds);
      if (updatedFavorites.contains(recipeId)) {
        updatedFavorites.remove(recipeId);
      } else {
        updatedFavorites.add(recipeId);
      }

      _tokenStorage.saveSavedRecipeIds(updatedFavorites);

      final updatedAll = current.allRecipes.map((r) {
        if (r.id == recipeId) {
          return r.copyWith(isFavorite: updatedFavorites.contains(recipeId));
        }
        return r;
      }).toList();

      final updatedPopular = current.popularRecipes.map((r) {
        if (r.id == recipeId) {
          return r.copyWith(isFavorite: updatedFavorites.contains(recipeId));
        }
        return r;
      }).toList();

      final updatedRecommended = current.recommendedRecipes.map((r) {
        if (r.id == recipeId) {
          return r.copyWith(isFavorite: updatedFavorites.contains(recipeId));
        }
        return r;
      }).toList();

      emit(current.copyWith(
        favoriteRecipeIds: updatedFavorites,
        allRecipes: updatedAll,
        popularRecipes: updatedPopular,
        recommendedRecipes: updatedRecommended,
      ));
    }
  }
}
