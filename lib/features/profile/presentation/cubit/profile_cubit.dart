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
  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    try {
      final profile = await _getProfileUseCase();
      emit(ProfileLoaded(profile));
    } on Failure catch (f) {
      emit(ProfileError(f.message));
    } catch (e) {
      emit(ProfileError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
