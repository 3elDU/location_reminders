import 'package:flutter/material.dart';
import 'package:location_reminders/database.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(this.reminder, {super.key});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Text(
              reminder.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              spacing: 8,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.location_on_outlined),
                Expanded(child: Text(reminder.placeDescription)),
              ],
            ),
            if (reminder.note.isNotEmpty) Text(reminder.note),
          ],
        ),
      ),
    );
  }
}
