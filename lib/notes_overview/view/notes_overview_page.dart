import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_taking_app/edit_note/edit_note.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';
import 'package:notes_repository/notes_repository.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesOverviewBloc>(
      create: (context) => NotesOverviewBloc(
        notesRepository: context.read<NotesRepository>(),
      )..add(const NotesOverviewSubscriptionRequested()),
      child: const NotesOverviewView(),
    );
  }
}

class NotesOverviewView extends StatelessWidget {
  const NotesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Keep'),
        actions: const [
          NotesOverviewChangeViewButton(),
          ProfileButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<NotesOverviewBloc, NotesOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == NotesOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Something went wrong. Please restart the app!',
                    ),
                  ),
                );
            }
          },
          child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
            builder: (context, state) {
              if (state.notes.isEmpty) {
                if (state.status == NotesOverviewStatus.loading) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (state.status == NotesOverviewStatus.success) {
                  return const EmptyNotesOverviewContent();
                } else {
                  return const SizedBox();
                }
              }

              return CupertinoScrollbar(
                child: StaggeredGrid.count(
                  crossAxisCount: state.view == NotesView.multiColumn ? 2 : 1,
                  axisDirection: AxisDirection.down,
                  crossAxisSpacing: 8,
                  children: [
                    for (final note in state.notes)
                      NotesOverviewSingleNoteTile(
                        note: note,
                        onTap: () => Navigator.of(context).push(
                          EditNotePage.route(initialNote: note),
                        ),
                        onDeleted: () {},
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
