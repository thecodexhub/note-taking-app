import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_overview_event.dart';
part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({
    required NotesRepository notesRepository,
  })  : _notesRepository = notesRepository,
        super(const NotesOverviewState()) {
    on<NotesOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<NotesOverviewNoteSelectionRequested>(_onNoteSelectionRequested);
    on<NotesOverviewNoteClearSelection>(_onClearSelection);
    on<NotesOverviewNoteDeleted>(_onNoteDeleted);
    on<NotesOverviewUndoNoteDeletionRequested>(_onUndoDeletionRequested);
    on<NotesOverviewNoteViewChanged>(_onNoteViewChanged);
  }

  final NotesRepository _notesRepository;

  FutureOr<void> _onSubscriptionRequested(
    NotesOverviewSubscriptionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: NotesOverviewStatus.loading));

    await emit.forEach<List<Note>>(
      _notesRepository.getNotes(),
      onData: (notes) => state.copyWith(
        status: NotesOverviewStatus.success,
        notes: notes,
      ),
      onError: (_, __) => state.copyWith(
        status: NotesOverviewStatus.failure,
      ),
    );
  }

  FutureOr<void> _onNoteSelectionRequested(
    NotesOverviewNoteSelectionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final currentSelectedNotes = [...state.selectedNotes];
    final selectedNoteIsPresent = currentSelectedNotes.contains(event.note);

    if (selectedNoteIsPresent) {
      currentSelectedNotes.remove(event.note);

      if (currentSelectedNotes.isEmpty) {
        emit(state.copyWith(selectionView: NotesSelectionView.notSelected));
      }

      emit(state.copyWith(selectedNotes: currentSelectedNotes));
    } else {
      if (currentSelectedNotes.isEmpty) {
        emit(state.copyWith(selectionView: NotesSelectionView.selected));
      }

      currentSelectedNotes.add(event.note);
      emit(state.copyWith(selectedNotes: currentSelectedNotes));
    }
  }

  FutureOr<void> _onClearSelection(
    NotesOverviewNoteClearSelection event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(
      selectedNotes: const <Note>[],
      selectionView: NotesSelectionView.notSelected,
    ));
  }

  FutureOr<void> _onNoteDeleted(
    NotesOverviewNoteDeleted event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedNotes: state.selectedNotes));

    for (final note in state.selectedNotes) {
      await _notesRepository.deleteNote(note.id);
    }

    emit(state.copyWith(
      selectedNotes: const <Note>[],
      selectionView: NotesSelectionView.notSelected,
    ));
  }

  FutureOr<void> _onUndoDeletionRequested(
    NotesOverviewUndoNoteDeletionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final notesToBeRestored = state.lastDeletedNotes;

    for (final note in notesToBeRestored) {
      await _notesRepository.saveNote(note);
    }

    emit(state.copyWith(lastDeletedNotes: const <Note>[]));
  }

  FutureOr<void> _onNoteViewChanged(
    NotesOverviewNoteViewChanged event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(orientationView: event.orientationView));
  }
}
