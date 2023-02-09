part of 'profile_cubit.dart';

enum FetchStatus { notFetched, fetchSuccess, fetchFailure }

class ProfileState extends Equatable {
  const ProfileState({
    this.email = '',
    this.fullName = '',
    this.status = FetchStatus.notFetched,
    this.avatarUrl = '',
    this.errorMessage,
  });
  final String email;
  final String fullName;
  final FetchStatus status;
  final String avatarUrl;
  final String? errorMessage;

  @override
  List<Object> get props => [email, fullName, status, avatarUrl];

  ProfileState copyWith({
    String? email,
    String? fullName,
    FetchStatus? status,
    String? avatarUrl,
    String? errorMessage,
  }) {
    return ProfileState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
