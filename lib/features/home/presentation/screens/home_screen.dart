import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../data/models/recipe_ui_model.dart';
import '../widgets/category_chips.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/popular_recipe_card.dart';
import '../widgets/recommended_recipe_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late List<RecipeUiModel> _popularRecipes;
  late List<RecipeUiModel> _recommendedRecipes;

  @override
  void initState() {
    super.initState();
    _popularRecipes = List.from(RecipeUiModel.samplePopularRecipes);
    _recommendedRecipes = List.from(RecipeUiModel.sampleRecommendedRecipes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'All';
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _togglePopularFavorite(int index) {
    setState(() {
      final item = _popularRecipes[index];
      _popularRecipes[index] = item.copyWith(isFavorite: !item.isFavorite);
    });
  }

  void _toggleRecommendedFavorite(int index) {
    setState(() {
      final item = _recommendedRecipes[index];
      _recommendedRecipes[index] = item.copyWith(isFavorite: !item.isFavorite);
    });
  }

  List<RecipeUiModel> _filterRecipes(List<RecipeUiModel> list) {
    return list.where((recipe) {
      final matchesCategory = _selectedCategory == 'All' ||
          recipe.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          recipe.name.toLowerCase().contains(_searchQuery) ||
          recipe.cuisine.toLowerCase().contains(_searchQuery) ||
          recipe.category.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: _currentNavIndex == 0
            ? _buildHomeTab()
            : _currentNavIndex == 1
                ? _buildExploreTab()
                : _buildSavedTab(),
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

  Widget _buildHomeTab() {
    final filteredPopular = _filterRecipes(_popularRecipes);
    final filteredRecommended = _filterRecipes(_recommendedRecipes);
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
            onFilterTap: _showFilterBottomSheet,
          ),
        ),
        SliverToBoxAdapter(
          child: CategoryChips(
            selectedCategory: _selectedCategory,
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
          if (filteredPopular.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: AppSectionHeader(
                subtitle: 'TRENDING',
                title: 'Popular This Week',
                actionLabel: 'See all',
                onAction: _resetFilters,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredPopular.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final recipe = filteredPopular[index];
                    final originalIndex = _popularRecipes.indexOf(recipe);
                    return PopularRecipeCard(
                      recipe: recipe,
                      onFavoriteToggle: () =>
                          _togglePopularFavorite(originalIndex),
                      onTap: () => _showRecipeDetails(recipe),
                    );
                  },
                ),
              ),
            ),
          ],
          if (filteredRecommended.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: AppSectionHeader(
                subtitle: 'PERSONALIZED',
                title: 'Recommended For You',
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final recipe = filteredRecommended[index];
                  final originalIndex = _recommendedRecipes.indexOf(recipe);
                  return RecommendedRecipeTile(
                    recipe: recipe,
                    onFavoriteToggle: () =>
                        _toggleRecommendedFavorite(originalIndex),
                    onTap: () => _showRecipeDetails(recipe),
                  );
                },
                childCount: filteredRecommended.length,
              ),
            ),
          ],
        ],
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildExploreTab() {
    final allRecipes = [..._popularRecipes, ..._recommendedRecipes];
    final searchResults = _filterRecipes(allRecipes);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXPLORE',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('Discover Recipes', style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        HomeSearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onClear: () {
            _searchController.clear();
            _onSearchChanged('');
          },
          onFilterTap: _showFilterBottomSheet,
        ),
        CategoryChips(
          selectedCategory: _selectedCategory,
          onSelectCategory: _onCategorySelected,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: searchResults.isEmpty
              ? AppEmptyState(
                  icon: Icons.explore_off_rounded,
                  title: 'Nothing to Explore',
                  message:
                      'Try adjusting your search or browse a different category.',
                  actionLabel: 'Reset Filters',
                  onAction: _resetFilters,
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final recipe = searchResults[index];
                    return RecommendedRecipeTile(
                      recipe: recipe,
                      onTap: () => _showRecipeDetails(recipe),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSavedTab() {
    final favorites = [
      ..._popularRecipes.where((r) => r.isFavorite),
      ..._recommendedRecipes.where((r) => r.isFavorite),
    ];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR COLLECTION',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Saved Recipes', style: theme.textTheme.headlineMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${favorites.length}',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: favorites.isEmpty
              ? const AppEmptyState(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'No Saved Recipes',
                  message:
                      'Tap the bookmark icon on any recipe to save it for later.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final recipe = favorites[index];
                    return RecommendedRecipeTile(
                      recipe: recipe,
                      onTap: () => _showRecipeDetails(recipe),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showRecipeDetails(RecipeUiModel recipe) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.md),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          child: AppNetworkImage(
                            url: recipe.imageUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          recipe.name,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.gold,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${recipe.rating}  ·  ${recipe.reviewCount} reviews',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                recipe.cuisine,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.schedule_rounded,
                                label: 'Prep Time',
                                value: '${recipe.cookTimeMinutes} min',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.local_fire_department_outlined,
                                label: 'Calories',
                                value: '${recipe.calories} kcal',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.bar_chart_rounded,
                                label: 'Level',
                                value: recipe.difficulty,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.xl,
            AppSpacing.xxl,
            AppSpacing.xxxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Filter by Category', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Choose a category to narrow your results',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: CategoryChips.categories.map((cat) {
                  final isSelected = _selectedCategory == cat.label;
                  return FilterChip(
                    label: Text(cat.label),
                    selected: isSelected,
                    avatar: Icon(
                      cat.icon,
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.primaryLight,
                    ),
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    onSelected: (_) {
                      Navigator.pop(context);
                      _onCategorySelected(cat.label);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryLight, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
