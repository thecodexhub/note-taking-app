import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/notes_repository.dart';

part 'edit_note_event.dart';
part 'edit_note_state.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNoteBloc({
    required NotesRepository notesRepository,
    required Note? initialNote,
  })  : _notesRepository = notesRepository,
        super(
          EditNoteState(
            initialNote: initialNote,
            title: initialNote?.title ?? '',
            content: initialNote?.content ?? '',
          ),
        ) {
    on<EditNoteTitleChanged>(_onNoteTitleChanged);
    on<EditNoteContentChanged>(_onNoteContentChanged);
    on<EditNoteSubmitted>(_onNoteSubmitted);
  }

  final NotesRepository _notesRepository;

  FutureOr<void> _onNoteTitleChanged(
    EditNoteTitleChanged event,
    Emitter<EditNoteState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  FutureOr<void> _onNoteContentChanged(
    EditNoteContentChanged event,
    Emitter<EditNoteState> emit,
  ) {
    emit(state.copyWith(content: event.content));
  }

  FutureOr<void> _onNoteSubmitted(
    EditNoteSubmitted event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(state.copyWith(status: EditNoteStatus.loading));

    final newNote = Note(title: '', lastEdited: DateTime.now());
    final currentNote = (state.initialNote ?? newNote).copyWith(
      title: state.title,
      content: state.content,
      lastEdited: DateTime.now(),
    );

    try {
      await _notesRepository.saveNote(currentNote);
      emit(state.copyWith(status: EditNoteStatus.success));
    } catch (_) {
      emit(state.copyWith(status: EditNoteStatus.failure));
    }
  }
}
