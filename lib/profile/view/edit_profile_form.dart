import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:note_taking_app/home/home.dart';
import 'package:note_taking_app/profile/profile.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm(
      {super.key, required this.fullName, required this.avatarUrl});
  final String fullName;
  final String avatarUrl;

  static Route<void> route({
    required String fullName,
    required String avatarUrl,
  }) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => EditProfileForm(
          fullName: fullName,
          avatarUrl: avatarUrl,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => EditProfileCubit(
            context.read<AuthenticationRepository>(),
          )..initializeForm(fullName: fullName, avatarUrl: avatarUrl),
          child: _EditProfileFormView(),
        ),
      ),
    );
  }
}

class _EditProfileFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatarUrl = context.select(
      (EditProfileCubit cubit) => cubit.state.avatarUrl,
    );

    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.formzStatus.isSubmissionFailure ||
            state.uploadStatus == UploadStatus.uploadFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Update Profile Failure'),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Avatar(size: 32, imgUrl: avatarUrl),
            const SizedBox(height: 8.0),
            _ChangeAvatarButton(),
            const SizedBox(height: 8.0),
            _FullNameInput(),
            const SizedBox(height: 8.0),
            _SaveButton(),
          ],
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('editProfileForm_fullNameInput_textField'),
          initialValue: context.read<EditProfileCubit>().state.fullName,
          onChanged: context.read<EditProfileCubit>().fullNameChanged,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) =>
          previous.formzStatus != current.formzStatus ||
          previous.uploadStatus != current.uploadStatus,
      builder: (context, state) {
        if (state.uploadStatus == UploadStatus.uploadInProgress) {
          return const TextButton(
            onPressed: null,
            child: Text('Avatar is updating. Please wait...'),
          );
        }

        switch (state.formzStatus) {
          case FormzStatus.submissionInProgress:
            return const Center(child: CircularProgressIndicator());
          case FormzStatus.submissionSuccess:
            return const TextButton(
              onPressed: null,
              child: Text('Profile Information Saved!'),
            );
          default:
            return SizedBox(
              height: 45.0,
              child: ElevatedButton(
                key: const Key('editProfileForm_save_raisedButton'),
                style: ElevatedButton.styleFrom(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: state.formzStatus.isValidated
                    ? () => context.read<EditProfileCubit>().updateProfile()
                    : null,
                child: const Text('Save Updated Information'),
              ),
            );
        }
      },
    );
  }
}

class _ChangeAvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        switch (state.uploadStatus) {
          case UploadStatus.uploadInProgress:
            return const Center(child: CircularProgressIndicator());
          default:
            return TextButton(
              onPressed: () => context.read<EditProfileCubit>().uploadAvatar(),
              child: const Text('Change your profile avatar'),
            );
        }
      },
    );
  }
}
