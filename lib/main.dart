import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/api.dart';
import 'package:note_taking_app/app/app.dart';
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

  runApp(App(authenticationRepository: authenticationRepository));
}
