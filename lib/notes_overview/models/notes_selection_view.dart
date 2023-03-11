enum NotesSelectionView { notSelected, selected }

extension NotesSelectionViewX on NotesSelectionView {
  bool get isNotSelected {
    return this == NotesSelectionView.notSelected;
  }

  bool get isSelected {
    return this == NotesSelectionView.selected;
  }
}
