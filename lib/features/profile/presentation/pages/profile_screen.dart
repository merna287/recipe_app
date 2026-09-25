import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_stats_card.dart';

/// Main screen for the Profile feature composing Clean Architecture modular widgets.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onLogoutConfirmed(BuildContext context) {
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated) {
          // Navigate to Auth login and clear navigation stack completely.
          // Prevents user from returning to authenticated screens with back button.
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh profile',
              onPressed: () => context.read<ProfileCubit>().loadProfile(forceRemote: true),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is ProfileError) {
                return Center(
                  child: AppEmptyState(
                    icon: Icons.person_off_rounded,
                    title: 'Profile Unavailable',
                    message: state.message,
                    actionLabel: 'Try Again',
                    onAction: () => context.read<ProfileCubit>().loadProfile(forceRemote: true),
                  ),
                );
              }

              if (state is ProfileLoaded) {
                final profile = state.profile;

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => context.read<ProfileCubit>().loadProfile(forceRemote: true),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProfileHeader(profile: profile),
                        const SizedBox(height: AppSpacing.xxl),
                        ProfileStatsCard(profile: profile),
                        const SizedBox(height: AppSpacing.xxl),
                        ProfileInfoSection(profile: profile),
                        const SizedBox(height: AppSpacing.xxl),
                        ProfileMenuSection(
                          onLogoutTap: () => LogoutDialog.show(
                            context,
                            onConfirmLogout: () => _onLogoutConfirmed(context),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
