import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/app/app.dart';
import 'package:note_taking_app/home/home.dart';
import 'package:note_taking_app/profile/profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FetchStatus.fetchFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _ShowProfile(),
            const SizedBox(height: 16),
            const Divider(),
            _UpdateProfileButton(),
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class _UpdateProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatarUrl = context.select(
      (ProfileCubit cubit) => cubit.state.avatarUrl,
    );
    final fullName = context.select(
      (ProfileCubit cubit) => cubit.state.fullName,
    );
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(EditProfileForm.route(fullName: fullName, avatarUrl: avatarUrl))
          .then((_) => context.read<ProfileCubit>().initializeProfile()),
      leading: const Icon(Icons.person_outlined),
      title: const Text('Edit profile information'),
    );
  }
}

class _ShowProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatarUrl = context.select(
      (ProfileCubit cubit) => cubit.state.avatarUrl,
    );
    final fullName = context.select(
      (ProfileCubit cubit) => cubit.state.fullName,
    );
    final email = context.select((ProfileCubit cubit) => cubit.state.email);
    return Row(
      children: [
        Avatar(size: 32, imgUrl: avatarUrl),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName.isEmpty ? 'No Name' : fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              email.isEmpty ? 'loading email...' : email,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.power_settings_new),
      title: const Text('Log out'),
      children: [
        const Text('Are you sure you want to log out?'),
        TextButton(
          onPressed: () {
            context.read<AppBloc>().add(const AppSignOutRequested());
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: const Text('CONFIRM'),
        ),
      ],
    );
  }
}
