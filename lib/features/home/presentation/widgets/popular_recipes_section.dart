import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/entities/recipe.dart';
import 'popular_recipe_card.dart';

/// Section widget rendering trending/popular recipes in a horizontal scrollable view.
class PopularRecipesSection extends StatelessWidget {
  final List<Recipe> recipes;
  final ValueChanged<Recipe> onRecipeTap;
  final ValueChanged<Recipe> onFavoriteToggle;
  final VoidCallback? onSeeAll;

  const PopularRecipesSection({
    super.key,
    required this.recipes,
    required this.onRecipeTap,
    required this.onFavoriteToggle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          subtitle: 'TRENDING',
          title: 'Popular This Week',
          actionLabel: onSeeAll != null ? 'See all' : null,
          onAction: onSeeAll,
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.lg),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return PopularRecipeCard(
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
