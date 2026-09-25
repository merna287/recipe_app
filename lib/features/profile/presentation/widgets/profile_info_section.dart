import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/user_profile.dart';

/// Section showing detailed personal information and contact metadata.
class ProfileInfoSection extends StatelessWidget {
  final UserProfile profile;

  const ProfileInfoSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            'Personal Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Username',
                value: '@${profile.username}',
                isDark: isDark,
              ),
              _buildDivider(isDark),
              _InfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                value: profile.email,
                isDark: isDark,
              ),
              if (profile.phone != null && profile.phone!.isNotEmpty) ...[
                _buildDivider(isDark),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: profile.phone!,
                  isDark: isDark,
                ),
              ],
              if (profile.gender != null && profile.gender!.isNotEmpty) ...[
                _buildDivider(isDark),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Account Role',
                  value: profile.gender!.toUpperCase(),
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
      indent: AppSpacing.xxl + 24,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
