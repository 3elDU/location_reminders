import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_reminders/components/map.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/main.dart';
import 'package:location_reminders/reminders_service.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _completed = widget.model.state == .completed;
    _locationFuture = context.read<RemindersService>().getLocation(
      widget.model,
    );
  }

  void _complete(BuildContext context) async {
    context.read<RemindersService>().complete(widget.model);
    setState(() {
      _completed = true;
    });
  }

  void _uncomplete(BuildContext context) async {
    context.read<RemindersService>().uncomplete(widget.model);
    setState(() {
      _completed = false;
    });
  }

  Widget _padded(Widget child) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: child);

  Widget _buildActionsStrip(Location? location) => Row(
    spacing: 8,
    children: [
      FilledButton.icon(
        icon: Icon(Icons.directions),
        label: Text('Directions'),
        onPressed: location == null
            ? null
            : () {
                launchUrlString(
                  'geo:0,0?q=${location.latitude},${location.longitude}(${widget.model.placeDescription})',
                );
              },
      ),
      FilledButton.tonalIcon(
        onPressed: _completed
            ? (() => _uncomplete(context))
            : (() => _complete(context)),
        icon: Icon(
          _completed ? Icons.add_circle_outline : Icons.check_circle_outline,
        ),
        label: Text(_completed ? 'Uncomplete' : 'Complete'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32),
        child: FutureBuilder(
          future: _locationFuture,
          builder: (context, snapshot) {
            final location = snapshot.data;

            return Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
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
                _padded(_buildActionsStrip(location)),
                _padded(
                  Card.filled(
                    margin: .zero,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(widget.model.note),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
