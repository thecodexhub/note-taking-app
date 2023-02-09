import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authenticationRepository) : super(const ProfileState());
  final AuthenticationRepository _authenticationRepository;

  Future<void> initializeProfile() async {
    try {
      final profile = await _authenticationRepository.getProfile();
      emit(state.copyWith(
        email: profile.email,
        fullName: profile.fullName,
        status: FetchStatus.fetchSuccess,
        avatarUrl: profile.avatarUrl,
      ));
    } on FetchProfileFailure catch (error) {
      emit(state.copyWith(
        status: FetchStatus.fetchFailure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(state.copyWith(status: FetchStatus.fetchFailure));
    }
  }
}
