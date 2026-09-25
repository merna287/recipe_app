import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/entities/recipe.dart';
import 'recommended_recipe_tile.dart';

/// Full tab view displaying the user's bookmarked/saved recipes.
class SavedTabView extends StatelessWidget {
  final List<Recipe> savedRecipes;
  final ValueChanged<Recipe> onRecipeTap;
  final ValueChanged<Recipe> onFavoriteToggle;

  const SavedTabView({
    super.key,
    required this.savedRecipes,
    required this.onRecipeTap,
    required this.onFavoriteToggle,
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
                    Text('Saved Recipes',
                        style: theme.textTheme.headlineMedium),
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
                  '${savedRecipes.length}',
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
          child: savedRecipes.isEmpty
              ? const AppEmptyState(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'No Saved Recipes',
                  message:
                      'Tap the bookmark icon on any recipe to save it for later.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: savedRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = savedRecipes[index];
                    return RecommendedRecipeTile(
                      recipe: recipe,
                      onFavoriteToggle: () => onFavoriteToggle(recipe),
                      onTap: () => onRecipeTap(recipe),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
