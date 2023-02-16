import 'package:notes_api/notes_api.dart';

/// {@template notes_repository}
/// A repository that handles notes related requests.
/// {@endtemplate}
class NotesRepository {
  /// {@macro notes_repository}
  const NotesRepository({
    required NotesApi notesApi,
  }) : _notesApi = notesApi;

  final NotesApi _notesApi;

  /// Provides a [Stream] of all notes.
  Stream<List<Note>> getNotes() => _notesApi.getNotes();

  /// Saves a [note].
  ///
  /// If a [note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note note) => _notesApi.saveNote(note);

  /// Deletes the `note` with the given id.
  ///
  /// If no `note` with the given id exists, a [NoteNotFoundException] error is
  /// thrown.
  Future<void> deleteNote(String id) => _notesApi.deleteNote(id);
}
