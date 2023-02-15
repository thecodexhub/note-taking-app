import 'package:notes_api/notes_api.dart';

/// {@template notes_api}
/// The interface and models for an API providing access to the notes.
/// {@endtemplate}
abstract class NotesApi {
  /// {@macro notes_api}
  const NotesApi();

  /// Provides a [Stream] of all notes.
  Stream<List<Note>> getNotes();

  /// Saves a [note].
  ///
  /// If a [note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note note);

  /// Deletes the `note` with the given id.
  ///
  /// If no `note` with the given id exists,
  /// a [NoteNotFoundException] error is thrown.
  Future<void> deleteNote(String id);
}

/// Error thrown when a [Note] with a given id is not found.
class NoteNotFoundException implements Exception {}
