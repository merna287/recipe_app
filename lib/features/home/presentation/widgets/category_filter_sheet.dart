import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'category_chips.dart';

/// Modal bottom sheet allowing users to filter recipes by culinary category.
class CategoryFilterSheet extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const CategoryFilterSheet({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  static Future<void> show(
    BuildContext context, {
    required String selectedCategory,
    required ValueChanged<String> onSelectCategory,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryFilterSheet(
        selectedCategory: selectedCategory,
        onSelectCategory: onSelectCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
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
              final isSelected = selectedCategory == cat.label;
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
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                onSelected: (_) {
                  Navigator.pop(context);
                  onSelectCategory(cat.label);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
