import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';

class NotesOverviewChangeViewButton extends StatelessWidget {
  const NotesOverviewChangeViewButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentView =
        context.select((NotesOverviewBloc bloc) => bloc.state.view);

    return IconButton(
      onPressed: () => context.read<NotesOverviewBloc>().add(
            NotesOverviewNoteViewChanged(
              currentView == NotesView.multiColumn
                  ? NotesView.singleColumn
                  : NotesView.multiColumn,
            ),
          ),
      icon: currentView == NotesView.multiColumn
          ? const Icon(Icons.grid_view)
          : const Icon(Icons.view_agenda_outlined),
    );
  }
}
