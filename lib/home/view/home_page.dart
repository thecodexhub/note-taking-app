import 'package:flutter/material.dart';
import 'package:note_taking_app/home/home.dart';
import 'package:note_taking_app/profile/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).push(ProfilePage.route()),
            child: const Avatar(),
          ),
        ],
      ),
    );
  }
}
