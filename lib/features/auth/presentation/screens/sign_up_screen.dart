import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_brand_hero.dart';
import '../widgets/auth_form_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context, AuthState state) {
    if (state is AuthLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().signUp(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            username: _usernameController.text,
            password: _passwordController.text,
          );
    }
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
                  content: Text(
                    'Welcome, ${state.session.username}! Your account is ready.',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state is AuthRegistrationComplete) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                      AuthBrandHero(
                        heightFactor: 0.26,
                        title: 'Join Savoré',
                        subtitle:
                            'Create your account and start discovering\nrecipes tailored to your taste.',
                      ),
                      AuthFormCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Create Account',
                                style: theme.textTheme.headlineMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Fill in your details to get started',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.xxl),

                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: _firstNameController,
                                      label: 'First Name',
                                      hint: 'John',
                                      prefixIcon: Icons.person_outline_rounded,
                                      enabled: !isLoading,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) =>
                                          AuthValidators.required(
                                            v,
                                            'first name',
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: AppTextField(
                                      controller: _lastNameController,
                                      label: 'Last Name',
                                      hint: 'Doe',
                                      enabled: !isLoading,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) =>
                                          AuthValidators.required(
                                            v,
                                            'last name',
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              AppTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'you@example.com',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.next,
                                validator: AuthValidators.email,
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              AppTextField(
                                controller: _usernameController,
                                label: 'Username',
                                hint: 'Choose a unique username',
                                prefixIcon: Icons.alternate_email_rounded,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.next,
                                validator: AuthValidators.username,
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              AppTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'At least 6 characters',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.next,
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
                              const SizedBox(height: AppSpacing.lg),

                              AppTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Re-enter your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: _obscureConfirmPassword,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () =>
                                    _onSignUpPressed(context, state),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 22,
                                    color: AppColors.textTertiary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) =>
                                    AuthValidators.confirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxl),

                              AppPrimaryButton(
                                label: 'Create Account',
                                isLoading: isLoading,
                                onPressed: isLoading
                                    ? null
                                    : () => _onSignUpPressed(context, state),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.lg,
                          bottom: AppSpacing.xxl,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.login,
                                      ),
                              child: const Text(
                                'Sign In',
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
