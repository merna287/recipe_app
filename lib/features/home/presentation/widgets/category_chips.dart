import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class CategoryItem {
  final String label;
  final IconData icon;

  const CategoryItem({
    required this.label,
    required this.icon,
  });
}

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  static const List<CategoryItem> categories = [
    CategoryItem(label: 'All', icon: Icons.grid_view_rounded),
    CategoryItem(label: 'Breakfast', icon: Icons.free_breakfast_rounded),
    CategoryItem(label: 'Lunch', icon: Icons.lunch_dining_rounded),
    CategoryItem(label: 'Dinner', icon: Icons.dinner_dining_rounded),
    CategoryItem(label: 'Pasta', icon: Icons.ramen_dining_rounded),
    CategoryItem(label: 'Seafood', icon: Icons.set_meal_rounded),
    CategoryItem(label: 'Healthy', icon: Icons.spa_rounded),
  ];

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              selectedCategory.toLowerCase() == category.label.toLowerCase();

          return GestureDetector(
            onTap: () => onSelectCategory(category.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 72,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected
                          ? null
                          : (isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.surface),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.border),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      category.icon,
                      size: 24,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryLight
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
