import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/utils/app_validators.dart';
import '../widgets/auth_brand_hero.dart';
import '../widgets/auth_form_card.dart';

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
                      const AuthBrandHero(
                        title: 'Welcome to\nSavoré',
                        subtitle:
                            'Sign in to explore curated recipes\ncrafted for every occasion.',
                      ),
                      AuthFormCard(
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
                                validator: AuthValidators.loginIdentifier,
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
                                validator: AuthValidators.password,
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

                      const Spacer(),

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
                                  : () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.signUp,
                                      ),
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
