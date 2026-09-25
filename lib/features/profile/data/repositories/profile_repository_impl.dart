import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final TokenStorage _tokenStorage;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _tokenStorage = tokenStorage;

  @override
  Future<UserProfile> getProfile({bool forceRemote = false}) async {
    // 1. If not forcing a remote refresh, reuse authenticated user data from local storage
    if (!forceRemote) {
      final localProfile = await _localDataSource.getLastProfile();
      if (localProfile != null) {
        return localProfile.toEntity();
      }
    }

    // 2. Verify active token exists
    final token = _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const AuthFailure('No active user session found.');
    }

    // 3. Local sessions cannot call remote DummyJSON /auth/me
    if (token.startsWith('local-')) {
      final localProfile = await _localDataSource.getLastProfile();
      if (localProfile != null) {
        return localProfile.toEntity();
      }
      throw const AuthFailure('User profile not found for the local session.');
    }

    // 4. Retrieve user data from remote authenticated endpoint (/auth/me)
    try {
      final remoteModel = await _remoteDataSource.getProfile();
      await _localDataSource.saveProfile(remoteModel);
      return remoteModel.toEntity();
    } on ServerException catch (e) {
      final localProfile = await _localDataSource.getLastProfile();
      if (localProfile != null) return localProfile.toEntity();
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      final localProfile = await _localDataSource.getLastProfile();
      if (localProfile != null) return localProfile.toEntity();
      throw NetworkFailure(e.message);
    } catch (e) {
      final localProfile = await _localDataSource.getLastProfile();
      if (localProfile != null) return localProfile.toEntity();
      throw ServerFailure('Unable to load profile: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedProfile() async {
    await _localDataSource.clearProfile();
  }
}
