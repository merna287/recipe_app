import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/entities/recipe.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/category_filter_sheet.dart';
import '../widgets/explore_tab_view.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/popular_recipes_section.dart';
import '../widgets/recipe_details_sheet.dart';
import '../widgets/recommended_recipes_section.dart';
import '../widgets/saved_tab_view.dart';

/// Main screen for the Home feature composing modular presentation widgets.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<HomeCubit>().search(query);
  }

  void _onCategorySelected(String category) {
    context.read<HomeCubit>().selectCategory(category);
  }

  void _resetFilters() {
    _searchController.clear();
    context.read<HomeCubit>().resetFilters();
  }

  void _openFilterSheet(String currentCategory) {
    CategoryFilterSheet.show(
      context,
      selectedCategory: currentCategory,
      onSelectCategory: _onCategorySelected,
    );
  }

  void _openRecipeDetails(Recipe recipe) {
    RecipeDetailsSheet.show(
      context,
      recipe: recipe,
      onFavoriteToggle: () {
        context.read<HomeCubit>().toggleFavorite(recipe.id);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: AppEmptyState(
                  icon: Icons.wifi_off_rounded,
                  title: 'Connection Issue',
                  message: state.message,
                  actionLabel: 'Try Again',
                  onAction: () => context.read<HomeCubit>().loadRecipes(),
                ),
              );
            }

            if (state is HomeLoaded) {
              return IndexedStack(
                index: _currentNavIndex,
                children: [
                  _buildHomeTab(state),
                  _buildExploreTab(state),
                  _buildSavedTab(state),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentNavIndex,
        onTabSelected: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.profile);
          } else {
            setState(() {
              _currentNavIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildHomeTab(HomeLoaded state) {
    final filteredPopular = state.filteredPopularRecipes;
    final filteredRecommended = state.filteredRecommendedRecipes;
    final hasResults =
        filteredPopular.isNotEmpty || filteredRecommended.isNotEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeader(
            onNotificationTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new recipe notifications at this time.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: HomeSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: () {
              _searchController.clear();
              _onSearchChanged('');
            },
            onFilterTap: () => _openFilterSheet(state.selectedCategory),
          ),
        ),
        SliverToBoxAdapter(
          child: CategoryChips(
            selectedCategory: state.selectedCategory,
            onSelectCategory: _onCategorySelected,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),
        const SliverToBoxAdapter(
          child: HomeHeroBanner(),
        ),
        if (!hasResults)
          SliverToBoxAdapter(
            child: AppEmptyState(
              icon: Icons.search_off_rounded,
              title: 'No Recipes Found',
              message:
                  'We couldn\'t find any recipes matching your search or category filter.',
              actionLabel: 'Reset Filters',
              onAction: _resetFilters,
            ),
          )
        else ...[
          if (filteredPopular.isNotEmpty)
            SliverToBoxAdapter(
              child: PopularRecipesSection(
                recipes: filteredPopular,
                onRecipeTap: _openRecipeDetails,
                onFavoriteToggle: (r) =>
                    context.read<HomeCubit>().toggleFavorite(r.id),
                onSeeAll: _resetFilters,
              ),
            ),
          if (filteredRecommended.isNotEmpty)
            SliverToBoxAdapter(
              child: RecommendedRecipesSection(
                recipes: filteredRecommended,
                onRecipeTap: _openRecipeDetails,
                onFavoriteToggle: (r) =>
                    context.read<HomeCubit>().toggleFavorite(r.id),
              ),
            ),
        ],
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildExploreTab(HomeLoaded state) {
    return ExploreTabView(
      recipes: state.filteredAllRecipes,
      searchController: _searchController,
      selectedCategory: state.selectedCategory,
      onSearchChanged: _onSearchChanged,
      onClearSearch: () {
        _searchController.clear();
        _onSearchChanged('');
      },
      onFilterTap: () => _openFilterSheet(state.selectedCategory),
      onSelectCategory: _onCategorySelected,
      onResetFilters: _resetFilters,
      onRecipeTap: _openRecipeDetails,
      onFavoriteToggle: (r) => context.read<HomeCubit>().toggleFavorite(r.id),
    );
  }

  Widget _buildSavedTab(HomeLoaded state) {
    return SavedTabView(
      savedRecipes: state.savedRecipes,
      onRecipeTap: _openRecipeDetails,
      onFavoriteToggle: (r) => context.read<HomeCubit>().toggleFavorite(r.id),
    );
  }
}
