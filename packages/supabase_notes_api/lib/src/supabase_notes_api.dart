import 'package:meta/meta.dart';
import 'package:notes_api/notes_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

/// {@template supabase_notes_api}
/// A Flutter implementation of the [NotesApi] that uses Supabase storage.
/// {@endtemplate}
class SupabaseNotesApi implements NotesApi {
  /// {@macro supabase_notes_api}
  const SupabaseNotesApi({
    required supabase_flutter.SupabaseClient client,
  }) : _client = client;

  final supabase_flutter.SupabaseClient _client;

  /// Profiles table name.
  ///
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const notesTable = 'notes-collection';

  @override
  Stream<List<Note>> getNotes() {
    return _client.from(notesTable).stream(primaryKey: ['id']).map(
      (notes) => notes.map(Note.fromJson).toList(),
    );
  }

  @override
  Future<void> saveNote(Note note) async {
    return _client.from(notesTable).upsert(note.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    return _client.from(notesTable).delete().eq('id', id);
  }
}
