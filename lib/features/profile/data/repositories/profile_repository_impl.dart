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
  Future<UserProfile> getProfile() async {
    final token = _tokenStorage.getToken();
    final isLocalSession = token != null && token.startsWith('local-');

    if (isLocalSession) {
      final cached = await _localDataSource.getLastProfile();
      if (cached != null) {
        return cached.toEntity();
      }
      return const UserProfile(
        id: 1,
        username: 'culinary_artist',
        email: 'chef@savore.com',
        firstName: 'Chef',
        lastName: 'Gourmet',
        gender: 'culinary',
      );
    }

    try {
      final remoteModel = await _remoteDataSource.getProfile();
      await _localDataSource.saveProfile(remoteModel);
      return remoteModel.toEntity();
    } on ServerException catch (e) {
      final cached = await _localDataSource.getLastProfile();
      if (cached != null) {
        return cached.toEntity();
      }
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      final cached = await _localDataSource.getLastProfile();
      if (cached != null) {
        return cached.toEntity();
      }
      throw NetworkFailure(e.message);
    } catch (e) {
      final cached = await _localDataSource.getLastProfile();
      if (cached != null) {
        return cached.toEntity();
      }
      throw ServerFailure('Unable to load profile: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedProfile() async {
    await _localDataSource.clearProfile();
  }
}
