import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_reminders/components/map.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/main.dart';
import 'package:location_reminders/models/reminder_handle.dart';
import 'package:location_reminders/services/database.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReminderDetailsPage extends StatefulWidget {
  const ReminderDetailsPage({super.key, required this.handle});

  final ReminderHandle handle;
  Reminder get model => handle.reminder;

  static void show(ReminderHandle handle) {
    navigatorGlobalKey.currentState!.push(
      MaterialPageRoute(builder: (_) => ReminderDetailsPage(handle: handle)),
    );
  }

  @override
  State<ReminderDetailsPage> createState() => _ReminderDetailsPageState();
}

class _ReminderDetailsPageState extends State<ReminderDetailsPage> {
  Location? _location = null;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    final location = await context.read<DatabaseService>().getLocation(
      widget.model,
    );
    setState(() {
      _location = location;
    });
  }

  Widget _padded(Widget child) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: child);

  Widget _buildActionsStrip() => Row(
    spacing: 8,
    children: [
      FilledButton.icon(
        icon: Icon(Icons.directions),
        label: Text('Directions'),
        onPressed: _location == null
            ? null
            : () {
                launchUrlString(
                  'geo:0,0?q=${_location!.latitude},${_location!.longitude}(${widget.model.placeDescription})',
                );
              },
      ),
      FilledButton.tonalIcon(
        onPressed: widget.model.state == .completed
            ? (() => widget.handle.uncomplete())
            : (() => widget.handle.complete()),
        icon: Icon(
          widget.model.state == .completed
              ? Icons.add_circle_outline
              : Icons.check_circle_outline,
        ),
        label: Text(
          widget.model.state == .completed ? 'Uncomplete' : 'Complete',
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32),
        child: ListenableBuilder(
          listenable: widget.handle,
          builder: (context, child) => Column(
            crossAxisAlignment: .stretch,
            spacing: 12,
            children: [
              SizedBox(
                height: 320,
                child: _location != null
                    ? WorldMap(
                        initialPosition: LatLng(
                          _location!.latitude,
                          _location!.longitude,
                        ),
                        markerPosition: LatLng(
                          _location!.latitude,
                          _location!.longitude,
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
              _padded(_buildActionsStrip()),
              if (widget.model.note.isNotEmpty)
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
          ),
        ),
      ),
    );
  }
}
