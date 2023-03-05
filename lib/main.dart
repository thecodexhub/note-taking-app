import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:note_taking_app/api.dart';
import 'package:note_taking_app/app/app.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Api.SUPABASE_URL,
    anonKey: Api.SUPABASE_ANON_KEY,
  );
  final client = Supabase.instance.client;

  final authenticationRepository = AuthenticationRepository(client: client);
  // await authenticationRepository.user.first;

  // final notesApi = SupabaseNotesApi(client: client);

  final notesApi = LocalStorageNotesApi(
    plugin: await SharedPreferences.getInstance(),
  );
  final notesRepository = NotesRepository(notesApi: notesApi);

  runApp(App(
    authenticationRepository: authenticationRepository,
    notesRepository: notesRepository,
  ));
}
