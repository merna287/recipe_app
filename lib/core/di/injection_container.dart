import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../storage/token_storage.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/recipe_remote_data_source.dart';
import '../../features/home/data/repositories/recipe_repository_impl.dart';
import '../../features/home/domain/repositories/recipe_repository.dart';
import '../../features/home/domain/usecases/get_recipes_usecase.dart';
import '../../features/home/domain/usecases/search_recipes_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final GetIt sl = GetIt.instance;

/// Centralized dependency injection initializer.
/// Asynchronously registers core singletons (Storage, Network, Dio)
/// before any feature UI or Cubits are built.
Future<void> initDependencies() async {
  //! 1. External (System / Device Services)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //! 2. Core - Local Storage
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<SharedPreferences>()),
  );

  //! 3. Core - Networking
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<TokenStorage>()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(authInterceptor: sl<AuthInterceptor>()),
  );

  sl.registerLazySingleton<Dio>(
    () => sl<ApiClient>().dio,
  );

  //! 4. Features - Auth
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );

  // Presentation (Cubits)
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl<LoginUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
    ),
  );

  //! 5. Features - Home
  // Data Source
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: sl<RecipeRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetRecipesUseCase>(
    () => GetRecipesUseCase(sl<RecipeRepository>()),
  );

  sl.registerLazySingleton<SearchRecipesUseCase>(
    () => SearchRecipesUseCase(sl<RecipeRepository>()),
  );

  // Presentation (Cubits)
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getRecipesUseCase: sl<GetRecipesUseCase>(),
      searchRecipesUseCase: sl<SearchRecipesUseCase>(),
    ),
  );
}
