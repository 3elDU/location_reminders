import 'package:flutter/material.dart';
import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/models/pending_note_model.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:provider/provider.dart';

class CreateNoteCard extends StatefulWidget {
  const CreateNoteCard({super.key});

  @override
  State<CreateNoteCard> createState() => _CreateNoteCardState();
}

class _CreateNoteCardState extends State<CreateNoteCard> {
  final _radii = <double>[50, 150, 500, 3000];

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _changeLocation() async {
    final location = await LocationPickerPage.pick();
    if (location == null || !mounted) return;

    context.read<PendingNoteModel>().updateLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.select<PendingNoteModel, Location>(
      (model) => model.location!,
    );

    return Card.outlined(
      margin: .zero,
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
              spacing: 12,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.location_on_outlined),
                Expanded(child: Text(location.description)),
                // a little padding on the right to align horizontally with other icons
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _changeLocation,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Icon(Icons.my_location_outlined),
                Expanded(
                  // LayoutBuilder is used here to specify a concrete non-infinite
                  // width value, as with ifinite width the dropdown menu is
                  // too wide and looks ugly.
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return DropdownMenu<double>(
                        width: constraints.maxWidth,
                        dropdownMenuEntries: _radii
                            .map(
                              (radius) => DropdownMenuEntry(
                                value: radius,
                                label: "${radius.toInt()} meters",
                              ),
                            )
                            .toList(),
                        initialSelection: _radii[1],
                        onSelected: (radius) {
                          if (radius == null) return;
                          context.read<PendingNoteModel>().updateRadius(radius);
                        },
                        selectOnly: true,
                        decorationBuilder: (_, _) => InputDecoration(
                          constraints: BoxConstraints(maxHeight: 48),
                          border: InputBorder.none,
                          contentPadding: .zero,
                          hintText: 'Radius',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Selector<PendingNoteModel, bool>(
              selector: (_, model) => model.onetime,
              // TODO: do something with the ripple effect
              builder: (_, onetime, _) => CheckboxListTile(
                splashRadius: 10,
                title: Text('One-time'),
                value: onetime,
                contentPadding: EdgeInsets.only(right: 8),
                onChanged: (value) {
                  context.read<PendingNoteModel>().updateOnetime(
                    value ?? false,
                  );
                },
              ),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Note',
                border: OutlineInputBorder(),
              ),
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
