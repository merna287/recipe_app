import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        username: username,
        password: password,
      );

      final saveSuccess = await _tokenStorage.saveToken(model.accessToken);
      if (!saveSuccess) {
        throw const CacheException(message: 'Failed to persist authentication token');
      }

      await _tokenStorage.saveUserSession(model.toJson());

      return model.toEntity();
    } on ServerException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 401) {
        final localSession = await _loginLocalUser(
          username: username,
          password: password,
        );
        if (localSession != null) {
          return localSession;
        }
        throw AuthFailure(e.message);
      }
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<AuthSession> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final registeredUser = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
        password: password,
      );

      await _tokenStorage.saveLocalRegisteredUser(
        id: registeredUser.id,
        username: registeredUser.username,
        password: password,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      return _createLocalSession(
        userId: registeredUser.id,
        username: registeredUser.username,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
    } on ServerException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 401) {
        throw AuthFailure(e.message);
      }
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthSession> _createLocalSession({
    required int userId,
    required String username,
    String? email,
    String? firstName,
    String? lastName,
  }) async {
    final localToken = 'local-$userId';
    final saveSuccess = await _tokenStorage.saveToken(localToken);
    if (!saveSuccess) {
      throw const CacheException(message: 'Failed to persist authentication token');
    }

    final userMap = {
      'id': userId,
      'username': username,
      'email': email ?? '$username@example.com',
      'firstName': firstName ?? username,
      'lastName': lastName ?? '',
    };
    await _tokenStorage.saveUserSession(userMap);

    return AuthSession(
      token: localToken,
      username: username,
      id: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<AuthSession?> _loginLocalUser({
    required String username,
    required String password,
  }) async {
    final localUser = _tokenStorage.findLocalRegisteredUser(
      username: username,
      password: password,
    );
    if (localUser == null) {
      return null;
    }

    return _createLocalSession(
      userId: localUser.id,
      username: localUser.username,
      email: localUser.email,
      firstName: localUser.firstName,
      lastName: localUser.lastName,
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _tokenStorage.clearUserSession();
      final cleared = await _tokenStorage.clearToken();
      if (!cleared) {
        throw const CacheException(message: 'Failed to clear session token');
      }
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure('Failed to logout: ${e.toString()}');
    }
  }
}
