import 'package:flutter/material.dart';

class NotesOverviewNotification extends StatelessWidget {
  const NotesOverviewNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.hoverColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(width: 0.3),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('🚀 All notes are saved locally.'),
      ),
    );
  }
}
