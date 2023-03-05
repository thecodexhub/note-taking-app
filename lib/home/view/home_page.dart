import 'package:flutter/material.dart';
import 'package:note_taking_app/edit_note/edit_note.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const NotesOverviewPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(EditNotePage.route()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
