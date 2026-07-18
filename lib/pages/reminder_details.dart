import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_reminders/components/map.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/main.dart';
import 'package:location_reminders/reminders_service.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:provider/provider.dart';

class ReminderDetailsPage extends StatefulWidget {
  const ReminderDetailsPage({super.key, required this.model});

  final Reminder model;

  static void show(Reminder model) {
    navigatorGlobalKey.currentState!.push(
      MaterialPageRoute(builder: (_) => ReminderDetailsPage(model: model)),
    );
  }

  @override
  State<ReminderDetailsPage> createState() => _ReminderDetailsPageState();
}

class _ReminderDetailsPageState extends State<ReminderDetailsPage> {
  late Future<Location> _locationFuture;

  @override
  void initState() {
    super.initState();

    _locationFuture = context.read<RemindersService>().getLocation(
      widget.model,
    );
  }

  void _delete(BuildContext context) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete this note'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (!confirmation || !context.mounted) return;

    context.read<RemindersService>().delete(widget.model);
    Navigator.pop(context);
  }

  Widget _padded(Widget child) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _locationFuture,
          builder: (context, snapshot) {
            final location = snapshot.data;

            return Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                SizedBox(
                  height: 320,
                  child: location != null
                      ? WorldMap(
                          initialPosition: LatLng(
                            location.latitude,
                            location.longitude,
                          ),
                          markerPosition: LatLng(
                            location.latitude,
                            location.longitude,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                        ),
                ),
                _padded(
                  Text(
                    widget.model.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                _padded(
                  Row(
                    spacing: 8,
                    crossAxisAlignment: .center,
                    children: [
                      Icon(Icons.location_on_outlined),
                      Expanded(child: Text(widget.model.placeDescription)),
                    ],
                  ),
                ),
                Divider(),
                _padded(Text(widget.model.note)),
              ],
            );
          },
        ),
      ),
    );
  }
}
