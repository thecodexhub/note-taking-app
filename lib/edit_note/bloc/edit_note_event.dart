part of 'edit_note_bloc.dart';

abstract class EditNoteEvent extends Equatable {
  const EditNoteEvent();

  @override
  List<Object> get props => [];
}

class EditNoteTitleChanged extends EditNoteEvent {
  const EditNoteTitleChanged(this.title);
  final String title;

  @override
  List<Object> get props => [title];
}

class EditNoteContentChanged extends EditNoteEvent {
  const EditNoteContentChanged(this.content);
  final String content;

  @override
  List<Object> get props => [content];
}

class EditNoteSubmitted extends EditNoteEvent {
  const EditNoteSubmitted();
}
