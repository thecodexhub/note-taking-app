part of 'notes_overview_bloc.dart';

abstract class NotesOverviewEvent extends Equatable {
  const NotesOverviewEvent();

  @override
  List<Object> get props => [];
}

class NotesOverviewSubscriptionRequested extends NotesOverviewEvent {
  const NotesOverviewSubscriptionRequested();
}

class NotesOverviewNoteSelectionRequested extends NotesOverviewEvent {
  const NotesOverviewNoteSelectionRequested(this.note);

  final Note note;

  @override
  List<Object> get props => [note];
}

class NotesOverviewNoteClearSelection extends NotesOverviewEvent {
  const NotesOverviewNoteClearSelection();
}

class NotesOverviewNoteDeleted extends NotesOverviewEvent {
  const NotesOverviewNoteDeleted();
}

class NotesOverviewUndoNoteDeletionRequested extends NotesOverviewEvent {
  const NotesOverviewUndoNoteDeletionRequested();
}

class NotesOverviewNoteViewChanged extends NotesOverviewEvent {
  const NotesOverviewNoteViewChanged(this.orientationView);

  final NotesOrientationView orientationView;

  @override
  List<Object> get props => [orientationView];
}
