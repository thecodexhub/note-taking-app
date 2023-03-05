import 'package:flutter/material.dart';
import 'package:notes_api/notes_api.dart';

class NotesOverviewSingleNoteTile extends StatelessWidget {
  const NotesOverviewSingleNoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDeleted,
  });
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: theme.textTheme.titleMedium,
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
