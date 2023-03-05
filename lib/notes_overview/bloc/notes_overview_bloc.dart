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

  FutureOr<void> _onNoteDeleted(
    NotesOverviewNoteDeleted event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedNote: event.note));
    await _notesRepository.deleteNote(event.note.id);
  }

  FutureOr<void> _onUndoDeletionRequested(
    NotesOverviewUndoNoteDeletionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedNote != null,
      'last deleted note cannot be null',
    );

    final note = state.lastDeletedNote!;
    emit(state.copyWith(lastDeletedNote: note));
    await _notesRepository.saveNote(note);
  }

  FutureOr<void> _onNoteViewChanged(
    NotesOverviewNoteViewChanged event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(view: event.view));
  }
}
