import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
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
      // 1. Authenticate with Remote Data Source
      final model = await _remoteDataSource.login(
        username: username,
        password: password,
      );

      // 2. Persist access token in TokenStorage
      final saveSuccess = await _tokenStorage.saveToken(model.accessToken);
      if (!saveSuccess) {
        throw const CacheException(message: 'Failed to persist authentication token');
      }

      // 3. Return domain entity
      return model.toEntity();
    } on ServerException catch (e) {
      if (e.statusCode == 400) {
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
}
