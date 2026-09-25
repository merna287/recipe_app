import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/user_profile.dart';

/// Top header of the profile screen presenting the avatar, full name,
/// username tag, and member status badge.
class ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: profile.image != null && profile.image!.isNotEmpty
                    ? Image.network(
                        profile.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackAvatar(),
                      )
                    : _buildFallbackAvatar(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBackground : AppColors.background,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          profile.fullName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            '@${profile.username}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 15,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: AppColors.primaryDark,
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }
}
