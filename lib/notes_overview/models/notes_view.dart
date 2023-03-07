enum NotesView { singleColumn, multiColumn }

extension NotesViewX on NotesView {
  bool get isSingleColumn {
    return this == NotesView.singleColumn;
  }

  bool get isMultiColumn {
    return this == NotesView.multiColumn;
  }
}
