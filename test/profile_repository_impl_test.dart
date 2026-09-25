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
    tokenStorage = TokenStorage(prefs);
    localDataSource = ProfileLocalDataSourceImpl(tokenStorage);
    repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      tokenStorage: tokenStorage,
    );
  });

  test('getProfile reuses existing user session from TokenStorage without remote call', () async {
    await tokenStorage.saveToken('dummy-token');
    await tokenStorage.saveUser({
      'id': 1,
      'username': 'emilys',
      'email': 'emily@example.com',
      'firstName': 'Emily',
      'lastName': 'Johnson',
    });

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 0); // No remote call
    expect(profile.username, 'emilys');
    expect(profile.fullName, 'Emily Johnson');
  });

  test('getProfile calls remote and saves session when TokenStorage has no session data', () async {
    await tokenStorage.saveToken('remote-token-123');

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 1);
    expect(profile.username, 'emilys');
    expect(profile.fullName, 'Emily Johnson');

    final savedSession = tokenStorage.getUser();
    expect(savedSession?['username'], 'emilys');
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

    final profile = await repository.getProfile(forceRemote: true);

    expect(profile.username, 'cacheduser');
    expect(profile.fullName, 'Cached Chef');
  });

  test('getProfile returns actual user for local session if session is persisted', () async {
    await tokenStorage.saveToken('local-999');
    await tokenStorage.saveUser({
      'id': 999,
      'username': 'localchef',
      'email': 'local@example.com',
      'firstName': 'Local',
      'lastName': 'Chef',
    });

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 0);
    expect(profile.username, 'localchef');
    expect(profile.fullName, 'Local Chef');
  });

  test('getProfile recovers user from local registered users when session was not cached yet', () async {
    await tokenStorage.saveLocalRegisteredUser(
      id: 555,
      username: 'legacyuser',
      password: 'password123',
      email: 'legacy@example.com',
      firstName: 'Legacy',
      lastName: 'User',
    );
    await tokenStorage.saveToken('local-555');

    final profile = await repository.getProfile();

    expect(remoteDataSource.callCount, 0);
    expect(profile.username, 'legacyuser');
    expect(profile.fullName, 'Legacy User');
    expect(profile.email, 'legacy@example.com');
  });
}
