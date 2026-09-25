import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection_container.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/sign_up_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'app_routes.dart';

/// Centralized route generator for Flutter.
/// Decouples navigation from individual widgets and screens.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => sl<AuthCubit>(),
            child: const SignUpScreen(),
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
