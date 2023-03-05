part of 'notes_overview_bloc.dart';

abstract class NotesOverviewEvent extends Equatable {
  const NotesOverviewEvent();

  @override
  List<Object> get props => [];
}

class NotesOverviewSubscriptionRequested extends NotesOverviewEvent {
  const NotesOverviewSubscriptionRequested();
}

class NotesOverviewNoteDeleted extends NotesOverviewEvent {
  const NotesOverviewNoteDeleted(this.note);

  final Note note;

  @override
  List<Object> get props => [note];
}

class NotesOverviewUndoNoteDeletionRequested extends NotesOverviewEvent {
  const NotesOverviewUndoNoteDeletionRequested();
}

class NotesOverviewNoteViewChanged extends NotesOverviewEvent {
  const NotesOverviewNoteViewChanged(this.view);

  final NotesView view;

  @override
  List<Object> get props => [view];
}
