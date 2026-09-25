import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/features/profile/domain/entities/user_profile.dart';
import 'package:recipe_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:recipe_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:recipe_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:recipe_app/features/profile/presentation/cubit/profile_state.dart';

class FakeProfileRepository implements ProfileRepository {
  bool shouldFail = false;

  @override
  Future<UserProfile> getProfile({bool forceRemote = false}) async {
    if (shouldFail) {
      throw const ServerFailure('Failed to load profile');
    }
    return const UserProfile(
      id: 1,
      username: 'emilys',
      email: 'emily@example.com',
      firstName: 'Emily',
      lastName: 'Johnson',
    );
  }

  @override
  Future<void> clearCachedProfile() async {}
}

void main() {
  late FakeProfileRepository repository;
  late GetProfileUseCase useCase;
  late ProfileCubit cubit;

  setUp(() {
    repository = FakeProfileRepository();
    useCase = GetProfileUseCase(repository);
    cubit = ProfileCubit(getProfileUseCase: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is ProfileInitial', () {
    expect(cubit.state, const ProfileInitial());
  });

  test('loadProfile emits ProfileLoading then ProfileLoaded on success', () async {
    final expectedStates = [
      const ProfileLoading(),
      isA<ProfileLoaded>().having(
        (s) => s.profile.username,
        'username',
        'emilys',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadProfile();
  });

  test('loadProfile emits ProfileLoading then ProfileError on failure', () async {
    repository.shouldFail = true;

    final expectedStates = [
      const ProfileLoading(),
      isA<ProfileError>().having(
        (s) => s.message,
        'message',
        'Failed to load profile',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadProfile();
  });
}
