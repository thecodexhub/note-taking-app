import 'package:flutter/material.dart';
import 'package:notes_api/notes_api.dart';

class NotesOverviewSingleNoteTile extends StatelessWidget {
  const NotesOverviewSingleNoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
    this.isSelected = false,
  });
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: isSelected ? 2.5 : 0.5,
            color: isSelected ? theme.colorScheme.secondary : const Color(0xFF000000),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(note.content, maxLines: 10, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
