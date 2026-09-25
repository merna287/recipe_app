import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/entities/recipe.dart';
import 'category_chips.dart';
import 'home_search_bar.dart';
import 'recommended_recipe_tile.dart';

/// Full tab view for exploring all recipes with search, category filtering, and list view.
class ExploreTabView extends StatelessWidget {
  final List<Recipe> recipes;
  final TextEditingController searchController;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSelectCategory;
  final VoidCallback onResetFilters;
  final ValueChanged<Recipe> onRecipeTap;
  final ValueChanged<Recipe>? onFavoriteToggle;

  const ExploreTabView({
    super.key,
    required this.recipes,
    required this.searchController,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterTap,
    required this.onSelectCategory,
    required this.onResetFilters,
    required this.onRecipeTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
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
          controller: searchController,
          onChanged: onSearchChanged,
          onClear: onClearSearch,
          onFilterTap: onFilterTap,
        ),
        CategoryChips(
          selectedCategory: selectedCategory,
          onSelectCategory: onSelectCategory,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: recipes.isEmpty
              ? AppEmptyState(
                  icon: Icons.explore_off_rounded,
                  title: 'Nothing to Explore',
                  message:
                      'Try adjusting your search or browse a different category.',
                  actionLabel: 'Reset Filters',
                  onAction: onResetFilters,
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecommendedRecipeTile(
                      recipe: recipe,
                      onFavoriteToggle: onFavoriteToggle != null
                          ? () => onFavoriteToggle!(recipe)
                          : null,
                      onTap: () => onRecipeTap(recipe),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
