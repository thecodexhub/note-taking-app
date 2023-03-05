part of 'notes_overview_bloc.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const <Note>[],
    this.view = NotesView.multiColumn,
    this.lastDeletedNote,
  });

  final NotesOverviewStatus status;
  final List<Note> notes;
  final NotesView view;
  final Note? lastDeletedNote;

  @override
  List<Object?> get props => [status, notes, view, lastDeletedNote];

  NotesOverviewState copyWith({
    NotesOverviewStatus? status,
    List<Note>? notes,
    NotesView? view,
    Note? lastDeletedNote,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      view: view ?? this.view,
      lastDeletedNote: lastDeletedNote ?? this.lastDeletedNote,
    );
  }
}
