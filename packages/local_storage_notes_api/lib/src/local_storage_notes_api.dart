import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:notes_api/notes_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_notes_api}
/// A Flutter implementation of the NotesApi that uses local storage
/// {@endtemplate}
class LocalStorageNotesApi extends NotesApi {
  /// {@macro local_storage_notes_api}
  LocalStorageNotesApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _initializeNotesStream();
  }

  final SharedPreferences _plugin;

  final _notesStreamController = BehaviorSubject<List<Note>>.seeded(const []);

  /// The key used for storing the notes locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__notes_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _initializeNotesStream() {
    final notesJson = _getValue(kNotesCollectionKey);
    if (notesJson != null) {
      final notes = List<Map<String, dynamic>>.from(
        json.decode(notesJson) as List,
      ).map(Note.fromJson).toList();
      _notesStreamController.add(notes);
    } else {
      _notesStreamController.add(const <Note>[]);
    }
  }

  @override
  Stream<List<Note>> getNotes() => _notesStreamController.asBroadcastStream();

  @override
  Future<void> saveNote(Note note) async {
    final notes = [..._notesStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == note.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = note;
    } else {
      notes.add(note);
    }

    _notesStreamController.add(notes);
    return _setValue(kNotesCollectionKey, json.encode(notes));
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = [..._notesStreamController.value];
    final noteIndexToBeDeleted = notes.indexWhere((note) => note.id == id);
    if (noteIndexToBeDeleted == -1) {
      throw NoteNotFoundException();
    } else {
      notes.removeAt(noteIndexToBeDeleted);
      _notesStreamController.add(notes);
      return _setValue(kNotesCollectionKey, json.encode(notes));
    }
  }
}
