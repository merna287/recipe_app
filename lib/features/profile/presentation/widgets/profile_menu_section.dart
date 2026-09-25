import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'profile_option_item.dart';

/// Grouped navigation and settings options for the profile view.
class ProfileMenuSection extends StatelessWidget {
  final VoidCallback onLogoutTap;

  const ProfileMenuSection({
    super.key,
    required this.onLogoutTap,
  });

  void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            'Settings & Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ProfileOptionItem(
          icon: Icons.manage_accounts_outlined,
          title: 'Account Settings',
          subtitle: 'Update your profile and email preferences',
          onTap: () => _showNotice(context, 'Account settings will be editable in the next update.'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileOptionItem(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: 'Recipe reminders and cooking alerts',
          onTap: () => _showNotice(context, 'Notification preferences saved.'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileOptionItem(
          icon: Icons.set_meal_outlined,
          title: 'Dietary Preferences',
          subtitle: 'Vegetarian, Vegan, Gluten-free filters',
          onTap: () => _showNotice(context, 'Dietary filters configured.'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileOptionItem(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'Theme styles and visual preferences',
          onTap: () => _showNotice(context, 'Savoré adapts automatically to your system theme.'),
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            'Support & Account',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ProfileOptionItem(
          icon: Icons.help_outline_rounded,
          title: 'Help Center & FAQs',
          subtitle: 'Frequently asked questions and guides',
          onTap: () => _showNotice(context, 'Visit support.savore.app for guides and assistance.'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileOptionItem(
          icon: Icons.info_outline_rounded,
          title: 'About Savoré',
          subtitle: 'Version 1.0.0 • Artisan Recipe Discovery',
          onTap: () => _showNotice(context, 'Savoré v1.0.0 — Crafted for culinary enthusiasts.'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileOptionItem(
          icon: Icons.logout_rounded,
          title: 'Log Out',
          subtitle: 'Sign out of your session on this device',
          isDestructive: true,
          onTap: onLogoutTap,
        ),
      ],
    );
  }
}
