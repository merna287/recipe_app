import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Recipe> popularRecipes;
  final List<Recipe> recommendedRecipes;
  final List<Recipe> allRecipes;
  final String selectedCategory;
  final String searchQuery;
  final Set<int> favoriteRecipeIds;

  const HomeLoaded({
    required this.popularRecipes,
    required this.recommendedRecipes,
    required this.allRecipes,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.favoriteRecipeIds = const {},
  });

  List<Recipe> get filteredPopularRecipes => _filterList(popularRecipes);
  List<Recipe> get filteredRecommendedRecipes => _filterList(recommendedRecipes);
  List<Recipe> get filteredAllRecipes => _filterList(allRecipes);

  List<Recipe> get savedRecipes {
    final seen = <int>{};
    final list = <Recipe>[];
    for (final r in allRecipes) {
      if (favoriteRecipeIds.contains(r.id) && seen.add(r.id)) {
        list.add(r);
      }
    }
    return list;
  }

  List<Recipe> _filterList(List<Recipe> list) {
    return list.where((recipe) {
      final matchesCategory = selectedCategory == 'All' ||
          recipe.category.toLowerCase() == selectedCategory.toLowerCase();
      final cleanQuery = searchQuery.trim().toLowerCase();
      final matchesQuery = cleanQuery.isEmpty ||
          recipe.name.toLowerCase().contains(cleanQuery) ||
          recipe.cuisine.toLowerCase().contains(cleanQuery) ||
          recipe.category.toLowerCase().contains(cleanQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  HomeLoaded copyWith({
    List<Recipe>? popularRecipes,
    List<Recipe>? recommendedRecipes,
    List<Recipe>? allRecipes,
    String? selectedCategory,
    String? searchQuery,
    Set<int>? favoriteRecipeIds,
  }) {
    return HomeLoaded(
      popularRecipes: popularRecipes ?? this.popularRecipes,
      recommendedRecipes: recommendedRecipes ?? this.recommendedRecipes,
      allRecipes: allRecipes ?? this.allRecipes,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
    );
  }

  @override
  List<Object?> get props => [
        popularRecipes,
        recommendedRecipes,
        allRecipes,
        selectedCategory,
        searchQuery,
        favoriteRecipeIds,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
