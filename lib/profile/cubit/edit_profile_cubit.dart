import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._authenticationRepository, {ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker(),
        super(const EditProfileState());

  final AuthenticationRepository _authenticationRepository;
  final ImagePicker _imagePicker;

  void initializeForm({required String fullName, required String avatarUrl}) {
    emit(state.copyWith(fullName: fullName, avatarUrl: avatarUrl));
  }

  void fullNameChanged(String value) {
    emit(state.copyWith(
      fullName: value,
      formzStatus: FormzStatus.valid,
    ));
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.updateProfile(
        username: state.fullName.replaceAll(' ', '').toLowerCase(),
        fullName: state.fullName,
        avatarUrl: state.avatarUrl,
      );
      emit(state.copyWith(formzStatus: FormzStatus.submissionSuccess));
    } on UpdateProfileFailure catch (error) {
      emit(state.copyWith(
        formzStatus: FormzStatus.submissionFailure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(state.copyWith(formzStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> uploadAvatar() async {
    final XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) return;

    emit(state.copyWith(uploadStatus: UploadStatus.uploadInProgress));
    final imageFileAsBytes = await imageFile.readAsBytes();
    try {
      final avatarUrl = await _authenticationRepository.uploadAvatar(
        imageFileAsBytes: imageFileAsBytes,
        imageFilePath: imageFile.path,
        contentType: imageFile.mimeType,
      );
      emit(
        state.copyWith(
          uploadStatus: UploadStatus.uploadSuccess,
          formzStatus: FormzStatus.valid,
          avatarUrl: avatarUrl,
        ),
      );
    } on UploadAvatarFailure catch (error) {
      emit(
        state.copyWith(
          uploadStatus: UploadStatus.uploadFailure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(state.copyWith(uploadStatus: UploadStatus.uploadFailure));
    }
  }
}
