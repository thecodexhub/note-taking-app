part of 'edit_profile_cubit.dart';

enum UploadStatus { notStarted, uploadInProgress, uploadSuccess, uploadFailure }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.fullName = '',
    this.avatarUrl = '',
    this.formzStatus = FormzStatus.pure,
    this.uploadStatus = UploadStatus.notStarted,
    this.errorMessage,
  });
  final String fullName;
  final String avatarUrl;
  final FormzStatus formzStatus;
  final UploadStatus uploadStatus;
  final String? errorMessage;

  @override
  List<Object> get props => [
        fullName,
        avatarUrl,
        formzStatus,
        uploadStatus,
      ];

  EditProfileState copyWith({
    String? fullName,
    String? avatarUrl,
    FormzStatus? formzStatus,
    UploadStatus? uploadStatus,
    String? errorMessage,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      formzStatus: formzStatus ?? this.formzStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
