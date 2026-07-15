import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_reminders/models/pending_note_model.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:provider/provider.dart';

class CreateNoteCard extends StatefulWidget {
  const CreateNoteCard({super.key});

  @override
  State<CreateNoteCard> createState() => _CreateNoteCardState();
}

class _CreateNoteCardState extends State<CreateNoteCard> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _changeLocation() async {
    final location = await LocationPickerPage.pick(context);
    if (location == null || !mounted) return;

    context.read<PendingNoteModel>().updateLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.select<PendingNoteModel, Location>(
      (model) => model.location!,
    );

    return Card.outlined(
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          spacing: 8,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: Theme.of(context).textTheme.headlineMedium,
              ),
              style: Theme.of(context).textTheme.headlineMedium,
              onChanged: (text) {
                context.read<PendingNoteModel>().updateTitle(text);
              },
            ),
            Row(
              spacing: 8,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.location_on_outlined),
                Text(
                  "${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}",
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.edit), onPressed: _changeLocation),
              ],
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(hintText: 'Note'),
              minLines: 2,
              maxLines: 10,
              onChanged: (text) {
                context.read<PendingNoteModel>().updateNote(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
