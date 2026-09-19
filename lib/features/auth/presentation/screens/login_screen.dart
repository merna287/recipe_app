import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Screen presenting the login form and observing [AuthCubit] state changes.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context, AuthState state) {
    if (state is AuthLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().login(
            username: _usernameController.text,
            password: _passwordController.text,
          );
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome back, ${state.session.username}!'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Brand hero
                      Container(
                        height: size.height * 0.32,
                        decoration: const BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -30,
                              top: -20,
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.06),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -40,
                              bottom: -30,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accent.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.xxl,
                                AppSpacing.xl,
                                AppSpacing.xxl,
                                AppSpacing.xxxl,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.soup_kitchen_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  const Text(
                                    'Welcome to\nSavoré',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.15,
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Sign in to explore curated recipes\ncrafted for every occasion.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withValues(alpha: 0.75),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form card
                      Transform.translate(
                        offset: const Offset(0, -28),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxl,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusXl),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.08),
                                  blurRadius: 32,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Enter your credentials to continue',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xxl),

                                  AppTextField(
                                    controller: _usernameController,
                                    label: 'Email',
                                    hint: 'Enter your email address',
                                    prefixIcon: Icons.mail_outline_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: !isLoading,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.lg),

                                  AppTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    hint: 'Enter your password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    enabled: !isLoading,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () =>
                                        _onLoginPressed(context, state),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        size: 22,
                                        color: AppColors.textTertiary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _showComingSoon(
                                                'Password recovery',
                                              ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primaryLight,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.sm,
                                        ),
                                      ),
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  AppPrimaryButton(
                                    label: 'Sign In',
                                    isLoading: isLoading,
                                    onPressed: isLoading
                                        ? null
                                        : () => _onLoginPressed(context, state),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Sign up link
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.xxl,
                          top: AppSpacing.sm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: theme.textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => _showComingSoon('Sign up'),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
