part of 'notes_overview_bloc.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const <Note>[],
    this.orientationView = NotesOrientationView.multiColumn,
    this.selectionView = NotesSelectionView.notSelected,
    this.selectedNotes = const <Note>[],
    this.lastDeletedNotes = const <Note>[],
  });

  final NotesOverviewStatus status;
  final List<Note> notes;
  final NotesOrientationView orientationView;
  final NotesSelectionView selectionView;
  final List<Note> selectedNotes;
  final List<Note> lastDeletedNotes;

  @override
  List<Object?> get props => [
        status,
        notes,
        orientationView,
        selectionView,
        selectedNotes,
        lastDeletedNotes,
      ];

  NotesOverviewState copyWith({
    NotesOverviewStatus? status,
    List<Note>? notes,
    NotesOrientationView? orientationView,
    NotesSelectionView? selectionView,
    List<Note>? selectedNotes,
    List<Note>? lastDeletedNotes,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      orientationView: orientationView ?? this.orientationView,
      selectionView: selectionView ?? this.selectionView,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      lastDeletedNotes: lastDeletedNotes ?? this.lastDeletedNotes,
    );
  }
}
