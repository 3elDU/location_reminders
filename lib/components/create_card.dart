import 'package:flutter/material.dart';
import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/models/pending_reminder.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:provider/provider.dart';

class CreateReminderCard extends StatefulWidget {
  const CreateReminderCard({super.key});

  @override
  State<CreateReminderCard> createState() => _CreateReminderCardState();
}

class _CreateReminderCardState extends State<CreateReminderCard> {
  final _radii = <double>[50, 150, 500, 3000];

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _titleController.text = context.read<PendingReminderModel>().title;
    _noteController.text = context.read<PendingReminderModel>().note;
  }

  void _changeLocation() async {
    final location = await LocationPickerPage.pick();
    if (location == null || !mounted) return;

    context.read<PendingReminderModel>().updateLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.select<PendingReminderModel, Location>(
      (model) => model.location,
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
                context.read<PendingReminderModel>().updateTitle(text);
              },
            ),
            Row(
              spacing: 12,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.location_on_outlined),
                Expanded(
                  child: Text(
                    location.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                // a little padding on the right to align ,horizontally with other icons
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
                        initialSelection: context
                            .read<PendingReminderModel>()
                            .radius,
                        onSelected: (radius) {
                          if (radius == null) return;
                          context.read<PendingReminderModel>().updateRadius(
                            radius,
                          );
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
            Selector<PendingReminderModel, bool>(
              selector: (_, model) => model.onetime,
              // TODO: do something with the ripple effect
              builder: (_, onetime, _) => CheckboxListTile(
                splashRadius: 10,
                title: Text('One-time'),
                value: onetime,
                contentPadding: EdgeInsets.only(right: 8),
                onChanged: (value) {
                  context.read<PendingReminderModel>().updateOnetime(
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
                context.read<PendingReminderModel>().updateNote(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
