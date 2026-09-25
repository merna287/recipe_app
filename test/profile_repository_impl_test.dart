import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/error/exceptions.dart';
import 'package:recipe_app/core/storage/token_storage.dart';
import 'package:recipe_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:recipe_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:recipe_app/features/profile/data/models/user_profile_model.dart';
import 'package:recipe_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  bool shouldFail = false;
  int callCount = 0;

  @override
  Future<UserProfileModel> getProfile() async {
    callCount++;
    if (shouldFail) {
      throw const ServerException(message: 'Profile fetch failed', statusCode: 500);
    }
    return const UserProfileModel(
      id: 1,
      username: 'emilys',
      email: 'emily@example.com',
      firstName: 'Emily',
      lastName: 'Johnson',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeProfileRemoteDataSource remoteDataSource;
  late ProfileLocalDataSourceImpl localDataSource;
  late TokenStorage tokenStorage;
  late ProfileRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    remoteDataSource = FakeProfileRemoteDataSource();
    localDataSource = ProfileLocalDataSourceImpl(prefs);
    tokenStorage = TokenStorage(prefs);
    repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      tokenStorage: tokenStorage,
    );
  });

  test('getProfile fetches from remote and caches on success', () async {
    await tokenStorage.saveToken('remote-token-123');

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 1);
    expect(profile.username, 'emilys');
    expect(profile.fullName, 'Emily Johnson');

    final cached = await localDataSource.getLastProfile();
    expect(cached?.username, 'emilys');
  });

  test('getProfile returns cached profile when remote fails', () async {
    await tokenStorage.saveToken('remote-token-123');
    await localDataSource.saveProfile(const UserProfileModel(
      id: 2,
      username: 'cacheduser',
      email: 'cached@example.com',
      firstName: 'Cached',
      lastName: 'Chef',
    ));

    remoteDataSource.shouldFail = true;

    final profile = await repository.getProfile();

    expect(profile.username, 'cacheduser');
    expect(profile.fullName, 'Cached Chef');
  });

  test('getProfile returns fallback profile for local test session', () async {
    await tokenStorage.saveToken('local-999');

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 0); // Should not call remote
    expect(profile.username, 'culinary_artist');
  });
}
