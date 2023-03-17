import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_taking_app/edit_note/edit_note.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';
import 'package:notes_api/notes_api.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
          builder: (context, state) {
            if (state.selectionView.isNotSelected) {
              return const _NotesOverviewGeneralAppBar();
            }
            return const _NotesOverviewSelectionAppBar();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<NotesOverviewBloc, NotesOverviewState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
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
            ),
            BlocListener<NotesOverviewBloc, NotesOverviewState>(
              listenWhen: (previous, current) =>
                  current.lastDeletedNotes.isNotEmpty &&
                  previous.lastDeletedNotes != current.lastDeletedNotes,
              listener: (context, state) {
                final messenger = ScaffoldMessenger.of(context);
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        '${state.lastDeletedNotes.length} note(s) deleted.',
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context.read<NotesOverviewBloc>().add(
                                const NotesOverviewUndoNoteDeletionRequested(),
                              );
                        },
                      ),
                    ),
                  );
              },
            ),
          ],
          child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
            builder: (context, state) {
              final isMultiColumn = state.orientationView.isMultiColumn;

              if (state.notes.isEmpty) {
                if (state.status == NotesOverviewStatus.loading) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (state.status == NotesOverviewStatus.success) {
                  return const EmptyNotesOverviewContent();
                } else {
                  return const SizedBox();
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const NotesOverviewNotification(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimationLimiter(
                        child: StaggeredGrid.count(
                          crossAxisCount: isMultiColumn ? 2 : 1,
                          axisDirection: AxisDirection.down,
                          crossAxisSpacing: 2,
                          children: [
                            for (final note in state.notes)
                              AnimationConfiguration.staggeredGrid(
                                position: state.notes.indexOf(note),
                                columnCount: isMultiColumn ? 2 : 1,
                                duration: const Duration(milliseconds: 700),
                                child: SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: _NotesOverviewSingleNoteTileWidget(
                                      note: note,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotesOverviewSingleNoteTileWidget extends StatelessWidget {
  const _NotesOverviewSingleNoteTileWidget({
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    final state = context.select((NotesOverviewBloc bloc) => bloc.state);

    return NotesOverviewSingleNoteTile(
      note: note,
      onTap: () => state.selectionView.isSelected
          ? context.read<NotesOverviewBloc>().add(
                NotesOverviewNoteSelectionRequested(note),
              )
          : Navigator.of(context).push(
              EditNotePage.route(initialNote: note),
            ),
      onLongPress: () => context.read<NotesOverviewBloc>().add(
            NotesOverviewNoteSelectionRequested(note),
          ),
      isSelected: state.selectedNotes.contains(note),
    );
  }
}

class _NotesOverviewGeneralAppBar extends StatelessWidget {
  const _NotesOverviewGeneralAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Notes Keep'),
      elevation: 0.0,
      scrolledUnderElevation: 2.5,
      actions: const [
        NotesOverviewChangeViewButton(),
        ProfileButton(),
      ],
    );
  }
}

class _NotesOverviewSelectionAppBar extends StatelessWidget {
  const _NotesOverviewSelectionAppBar();

  @override
  Widget build(BuildContext context) {
    final state = context.select((NotesOverviewBloc bloc) => bloc.state);

    return AppBar(
      title: Text(state.selectedNotes.length.toString()),
      leading: IconButton(
        onPressed: () => context.read<NotesOverviewBloc>().add(
              const NotesOverviewNoteClearSelection(),
            ),
        icon: const Icon(Icons.clear),
      ),
      elevation: 2.5,
      scrolledUnderElevation: 2.5,
      actions: [
        IconButton(
          onPressed: () => context.read<NotesOverviewBloc>().add(
                const NotesOverviewNoteDeleted(),
              ),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
