import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taking_app/app/app.dart';
import 'package:note_taking_app/notes_overview/notes_overview.dart';
import 'package:notes_repository/notes_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
    required NotesRepository notesRepository,
  })  : _authenticationRepository = authenticationRepository,
        _notesRepository = notesRepository;

  final AuthenticationRepository _authenticationRepository;
  final NotesRepository _notesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider<NotesRepository>.value(
          value: _notesRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<NotesOverviewBloc>(
            create: (context) => NotesOverviewBloc(
              notesRepository: _notesRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
