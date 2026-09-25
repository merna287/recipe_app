import 'package:flutter/material.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/entities/recipe.dart';
import 'recommended_recipe_tile.dart';

/// Section widget rendering recommended recipes with section header.
class RecommendedRecipesSection extends StatelessWidget {
  final List<Recipe> recipes;
  final ValueChanged<Recipe> onRecipeTap;
  final ValueChanged<Recipe> onFavoriteToggle;

  const RecommendedRecipesSection({
    super.key,
    required this.recipes,
    required this.onRecipeTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          subtitle: 'PERSONALIZED',
          title: 'Recommended For You',
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return RecommendedRecipeTile(
              recipe: recipe,
              onFavoriteToggle: () => onFavoriteToggle(recipe),
              onTap: () => onRecipeTap(recipe),
            );
          },
        ),
      ],
    );
  }
}
