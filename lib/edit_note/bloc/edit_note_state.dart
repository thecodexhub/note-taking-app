part of 'edit_note_bloc.dart';

enum EditNoteStatus { initial, loading, success, failure }

extension EditNoteStatusX on EditNoteStatus {
  bool get isLoadingOrSuccess {
    return [
      EditNoteStatus.loading,
      EditNoteStatus.success,
    ].contains(this);
  }
}

class EditNoteState extends Equatable {
  const EditNoteState({
    this.status = EditNoteStatus.initial,
    this.initialNote,
    this.title = '',
    this.content = '',
  });

  final EditNoteStatus status;
  final Note? initialNote;
  final String title;
  final String content;

  bool get isNewNote => initialNote == null;

  @override
  List<Object?> get props => [status, initialNote, title, content];

  EditNoteState copyWith({
    EditNoteStatus? status,
    Note? initialNote,
    String? title,
    String? content,
  }) {
    return EditNoteState(
      status: status ?? this.status,
      initialNote: initialNote ?? this.initialNote,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
