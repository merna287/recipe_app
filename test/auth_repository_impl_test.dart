import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/error/exceptions.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/storage/token_storage.dart';
import 'package:recipe_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:recipe_app/features/auth/data/models/login_response_model.dart';
import 'package:recipe_app/features/auth/data/models/register_response_model.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  int loginCalls = 0;
  int registerCalls = 0;

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    loginCalls++;
    if (username == 'emilys' && password == 'emilyspass') {
      return const LoginResponseModel(
        id: 1,
        username: 'emilys',
        email: 'emily@example.com',
        firstName: 'Emily',
        lastName: 'Johnson',
        gender: 'female',
        image: '',
        accessToken: 'dummy-token',
      );
    }

    throw const ServerException(
      message: 'Invalid credentials',
      statusCode: 400,
    );
  }

  @override
  Future<RegisterResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    registerCalls++;
    return RegisterResponseModel(
      id: 209,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRemoteDataSource remoteDataSource;
  late TokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    remoteDataSource = FakeAuthRemoteDataSource();
    tokenStorage = TokenStorage(prefs);
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      tokenStorage: tokenStorage,
    );
  });

  test('login uses DummyJSON for existing credentials', () async {
    final session = await repository.login(
      username: 'emilys',
      password: 'emilyspass',
    );

    expect(remoteDataSource.loginCalls, 1);
    expect(session.username, 'emilys');
    expect(session.fullName, 'Emily Johnson');
    expect(session.token, 'dummy-token');
    expect(tokenStorage.getToken(), 'dummy-token');
    expect(tokenStorage.getUserSession()?['username'], 'emilys');
    expect(tokenStorage.getUserSession()?['email'], 'emily@example.com');
  });

  test('signUp creates local session without DummyJSON login', () async {
    final session = await repository.signUp(
      firstName: 'New',
      lastName: 'User',
      email: 'new@example.com',
      username: 'newuser',
      password: 'secret123',
    );

    expect(remoteDataSource.registerCalls, 1);
    expect(remoteDataSource.loginCalls, 0);
    expect(session.username, 'newuser');
    expect(session.fullName, 'New User');
    expect(session.token, 'local-209');
    expect(tokenStorage.getToken(), 'local-209');
    expect(tokenStorage.getUserSession()?['username'], 'newuser');
    expect(tokenStorage.getUserSession()?['email'], 'new@example.com');
  });

  test('login falls back to local session for registered user', () async {
    await repository.signUp(
      firstName: 'New',
      lastName: 'User',
      email: 'new@example.com',
      username: 'newuser',
      password: 'secret123',
    );

    await tokenStorage.clearToken();
    remoteDataSource.loginCalls = 0;

    final session = await repository.login(
      username: 'newuser',
      password: 'secret123',
    );

    expect(remoteDataSource.loginCalls, 1);
    expect(session.username, 'newuser');
    expect(session.fullName, 'New User');
    expect(session.token, 'local-209');
    expect(tokenStorage.getUserSession()?['username'], 'newuser');
  });

  test('login rejects unknown credentials', () async {
    expect(
      () => repository.login(username: 'unknown', password: 'wrong'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('logout clears persisted session token and user data from storage', () async {
    await tokenStorage.saveToken('active-token-123');
    await tokenStorage.saveUserSession({'username': 'emilys', 'id': 1});
    expect(tokenStorage.hasToken(), isTrue);
    expect(tokenStorage.getUserSession(), isNotNull);

    await repository.logout();

    expect(tokenStorage.hasToken(), isFalse);
    expect(tokenStorage.getToken(), isNull);
    expect(tokenStorage.getUserSession(), isNull);
  });
}

