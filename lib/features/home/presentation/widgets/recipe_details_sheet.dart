import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/recipe.dart';

/// Draggable modal sheet providing full details and nutritional stats for a recipe.
class RecipeDetailsSheet extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onFavoriteToggle;

  const RecipeDetailsSheet({
    super.key,
    required this.recipe,
    this.onFavoriteToggle,
  });

  static Future<void> show(
    BuildContext context, {
    required Recipe recipe,
    VoidCallback? onFavoriteToggle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecipeDetailsSheet(
        recipe: recipe,
        onFavoriteToggle: onFavoriteToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      child: AppNetworkImage(
                        url: recipe.imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        if (onFavoriteToggle != null)
                          IconButton(
                            icon: Icon(
                              recipe.isFavorite
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded,
                              color: recipe.isFavorite
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                            ),
                            onPressed: onFavoriteToggle,
                          ),
                      ],
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
                          child: RecipeStatCard(
                            icon: Icons.schedule_rounded,
                            label: 'Prep Time',
                            value: '${recipe.cookTimeMinutes} min',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: RecipeStatCard(
                            icon: Icons.local_fire_department_outlined,
                            label: 'Calories',
                            value: '${recipe.calories} kcal',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: RecipeStatCard(
                            icon: Icons.bar_chart_rounded,
                            label: 'Level',
                            value: recipe.difficulty,
                          ),
                        ),
                      ],
                    ),
                    if (recipe.ingredients.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxl),
                      Text('Ingredients', style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      ...recipe.ingredients.map(
                        (ingredient) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (recipe.instructions.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxl),
                      Text('Instructions', style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      ...recipe.instructions.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.primaryLight
                                    .withValues(alpha: 0.15),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Stat display card component used in recipe details.
class RecipeStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const RecipeStatCard({
    super.key,
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
        color:
            isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
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
              color:
                  isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
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
