enum NotesOrientationView { singleColumn, multiColumn }

extension NotesOrientationViewX on NotesOrientationView {
  bool get isSingleColumn {
    return this == NotesOrientationView.singleColumn;
  }

  bool get isMultiColumn {
    return this == NotesOrientationView.multiColumn;
  }
}
