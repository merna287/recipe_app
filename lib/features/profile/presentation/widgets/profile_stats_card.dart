import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/user_profile.dart';

/// Card displaying user engagement metrics (cooked, saved, and reviews).
class ProfileStatsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileStatsCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            count: '${profile.cookedRecipesCount}',
            label: 'Cooked',
            icon: Icons.restaurant_menu_rounded,
            color: AppColors.primaryLight,
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _StatItem(
            count: '${profile.savedRecipesCount}',
            label: 'Saved',
            icon: Icons.bookmark_rounded,
            color: AppColors.accent,
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _StatItem(
            count: '${profile.reviewsCount}',
            label: 'Reviews',
            icon: Icons.star_rounded,
            color: AppColors.gold,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 36,
      width: 1,
      color: isDark ? AppColors.darkBorder : AppColors.border,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
