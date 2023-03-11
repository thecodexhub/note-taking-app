import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';

class NotesOverviewChangeViewButton extends StatelessWidget {
  const NotesOverviewChangeViewButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentOrientationView = context.select(
      (NotesOverviewBloc bloc) => bloc.state.orientationView,
    );

    return IconButton(
      onPressed: () => context.read<NotesOverviewBloc>().add(
            NotesOverviewNoteViewChanged(
              currentOrientationView == NotesOrientationView.multiColumn
                  ? NotesOrientationView.singleColumn
                  : NotesOrientationView.multiColumn,
            ),
          ),
      icon: currentOrientationView == NotesOrientationView.multiColumn
          ? const Icon(Icons.grid_view)
          : const Icon(Icons.view_agenda_outlined),
    );
  }
}
