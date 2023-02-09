import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
        builder: (_) => const ProfilePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(
            context.read<AuthenticationRepository>(),
          )..initializeProfile(),
          child: const ProfileView(),
        ),
      ),
    );
  }
}
