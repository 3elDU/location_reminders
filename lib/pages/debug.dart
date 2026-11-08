import 'package:flutter/material.dart';
import 'package:location_reminders/xnopyt.dart';
import 'package:native_geofence/native_geofence.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  List<String> _geofenceIds = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final ids = await NativeGeofenceManager.instance.getRegisteredGeofenceIds();
    setState(() {
      _geofenceIds = ids;
    });
  }

  void _clearGeofences() async {
    await NativeGeofenceManager.instance.removeAllGeofences();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Geofences (${_geofenceIds.length})'),
            subtitle: Text(_geofenceIds.join(', ')),
            trailing: _geofenceIds.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Clear all',
                    onPressed: _clearGeofences,
                  )
                : null,
          ),
          ListTile(title: Text('Xnopyt'), onTap: playXnopyt),
        ],
      ),
    );
  }
}
