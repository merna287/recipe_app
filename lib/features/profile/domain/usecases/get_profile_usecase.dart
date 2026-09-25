import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Domain use case for retrieving current user profile.
class GetProfileUseCase {
  final ProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  Future<UserProfile> call() async {
    return await _repository.getProfile();
  }
}
