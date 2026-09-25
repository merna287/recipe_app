import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

/// Cubit managing the profile screen state and profile fetching.
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        super(const ProfileInitial());

  /// Loads profile data for the authenticated user.
  Future<void> loadProfile({bool forceRemote = false}) async {
    emit(const ProfileLoading());

    try {
      final profile = await _getProfileUseCase(forceRemote: forceRemote);
      emit(ProfileLoaded(profile));
    } on Failure catch (f) {
      emit(ProfileError(f.message));
    } catch (e) {
      emit(ProfileError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
