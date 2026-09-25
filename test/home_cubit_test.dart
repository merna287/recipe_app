import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/storage/token_storage.dart';
import 'package:recipe_app/features/home/domain/entities/recipe.dart';
import 'package:recipe_app/features/home/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/features/home/domain/usecases/get_recipes_usecase.dart';
import 'package:recipe_app/features/home/domain/usecases/search_recipes_usecase.dart';
import 'package:recipe_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:recipe_app/features/home/presentation/cubit/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRecipeRepository implements RecipeRepository {
  final List<Recipe> recipes;

  MockRecipeRepository(this.recipes);

  @override
  Future<List<Recipe>> getRecipes() async => recipes;

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    return recipes
        .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRecipeRepository mockRepository;
  late GetRecipesUseCase getRecipesUseCase;
  late SearchRecipesUseCase searchRecipesUseCase;
  late TokenStorage tokenStorage;
  late HomeCubit cubit;

  final sampleRecipes = [
    const Recipe(
      id: 1,
      name: 'Pasta Carbonara',
      imageUrl: '',
      rating: 4.9,
      reviewCount: 100,
      cookTimeMinutes: 20,
      difficulty: 'Medium',
      cuisine: 'Italian',
      calories: 500,
      category: 'Pasta',
    ),
    const Recipe(
      id: 2,
      name: 'Caesar Salad',
      imageUrl: '',
      rating: 4.7,
      reviewCount: 80,
      cookTimeMinutes: 10,
      difficulty: 'Easy',
      cuisine: 'American',
      calories: 250,
      category: 'Healthy',
    ),
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    tokenStorage = TokenStorage(prefs);
    mockRepository = MockRecipeRepository(sampleRecipes);
    getRecipesUseCase = GetRecipesUseCase(mockRepository);
    searchRecipesUseCase = SearchRecipesUseCase(mockRepository);
    cubit = HomeCubit(
      getRecipesUseCase: getRecipesUseCase,
      searchRecipesUseCase: searchRecipesUseCase,
      tokenStorage: tokenStorage,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is HomeInitial', () {
    expect(cubit.state, const HomeInitial());
  });

  test('loadRecipes emits HomeLoading then HomeLoaded', () async {
    final expectedStates = [
      isA<HomeLoading>(),
      isA<HomeLoaded>(),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadRecipes();

    final state = cubit.state as HomeLoaded;
    expect(state.allRecipes.length, 2);
    expect(state.popularRecipes.length, 2);
  });

  test('toggleFavorite updates favorite set and recipe flag', () async {
    await cubit.loadRecipes();

    cubit.toggleFavorite(1);
    var state = cubit.state as HomeLoaded;
    expect(state.favoriteRecipeIds.contains(1), isTrue);
    expect(state.savedRecipes.length, 1);

    cubit.toggleFavorite(1);
    state = cubit.state as HomeLoaded;
    expect(state.favoriteRecipeIds.contains(1), isFalse);
    expect(state.savedRecipes.isEmpty, isTrue);
  });

  test('selectCategory and resetFilters update state', () async {
    await cubit.loadRecipes();

    cubit.selectCategory('Pasta');
    var state = cubit.state as HomeLoaded;
    expect(state.selectedCategory, 'Pasta');
    expect(state.filteredAllRecipes.length, 1);
    expect(state.filteredAllRecipes.first.name, 'Pasta Carbonara');

    cubit.resetFilters();
    state = cubit.state as HomeLoaded;
    expect(state.selectedCategory, 'All');
    expect(state.filteredAllRecipes.length, 2);
  });

  test('persists saved recipes to TokenStorage and restores them on loadRecipes', () async {
    await cubit.loadRecipes();
    cubit.toggleFavorite(1);
    expect(tokenStorage.getSavedRecipeIds(), {1});

    final newCubit = HomeCubit(
      getRecipesUseCase: getRecipesUseCase,
      searchRecipesUseCase: searchRecipesUseCase,
      tokenStorage: tokenStorage,
    );
    await newCubit.loadRecipes();
    final newState = newCubit.state as HomeLoaded;
    expect(newState.favoriteRecipeIds, {1});
    expect(newState.savedRecipes.length, 1);
    expect(newState.allRecipes.firstWhere((r) => r.id == 1).isFavorite, isTrue);
    newCubit.close();
  });
}
