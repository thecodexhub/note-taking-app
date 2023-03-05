import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_taking_app/edit_note/edit_note.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/notes_repository.dart';

class EditNotePage extends StatelessWidget {
  const EditNotePage({super.key});

  static Route<void> route({Note? initialNote}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => EditNoteBloc(
          notesRepository: context.read<NotesRepository>(),
          initialNote: initialNote,
        ),
        child: const EditNotePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNoteBloc, EditNoteState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditNoteStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditNoteView(),
    );
  }
}

class EditNoteView extends StatelessWidget {
  const EditNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditNoteBloc bloc) => bloc.state.status);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => status.isLoadingOrSuccess
                ? null
                : context.read<EditNoteBloc>().add(const EditNoteSubmitted()),
            icon: status.isLoadingOrSuccess
                ? const CupertinoActivityIndicator()
                : const Icon(Icons.save_alt),
            label: status.isLoadingOrSuccess
                ? const Text('Saving...')
                : const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            _EditNoteTitleField(),
            Expanded(child: _EditNoteContentField()),
            _EditNoteLastEditedField(),
          ],
        ),
      ),
    );
  }
}

class _EditNoteTitleField extends StatelessWidget {
  const _EditNoteTitleField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditNoteBloc bloc) => bloc.state);
    final theme = Theme.of(context);

    return TextFormField(
      initialValue: state.title,
      style: theme.textTheme.titleLarge,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        hintText: 'Enter Title Here',
        border: InputBorder.none,
      ),
      // maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<EditNoteBloc>().add(EditNoteTitleChanged(value));
      },
    );
  }
}

class _EditNoteContentField extends StatelessWidget {
  const _EditNoteContentField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditNoteBloc bloc) => bloc.state);

    return TextFormField(
      initialValue: state.content,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        hintText: 'Enter Content Here',
        border: InputBorder.none,
      ),
      // maxLength: 500,
      maxLines: null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(500),
      ],
      onChanged: (value) {
        context.read<EditNoteBloc>().add(EditNoteContentChanged(value));
      },
    );
  }
}

class _EditNoteLastEditedField extends StatelessWidget {
  const _EditNoteLastEditedField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditNoteBloc bloc) => bloc.state);
    final lastEdited = state.initialNote != null
        ? state.initialNote!.lastEdited
        : DateTime.now();

    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.Hm();

    return Center(
      child: Text('Edited ${dateFormat.format(lastEdited)} : '
          '${timeFormat.format(lastEdited)}'),
    );
  }
}
