import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location_reminders/callback.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.location.request();
  await Permission.locationAlways.request();

  final plugin = FlutterLocalNotificationsPlugin();
  plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()!
      .requestNotificationsPermission();

  await NativeGeofenceManager.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Reminders',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Location Reminders'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _radiusController = TextEditingController();

  List<ActiveGeofence> _geofences = [];

  @override
  void initState() {
    super.initState();
    _fetchRegisteredGeofences();
  }

  Future<void> _fetchRegisteredGeofences() async {
    final geofences = await NativeGeofenceManager.instance
        .getRegisteredGeofences();

    setState(() {
      _geofences = geofences;
    });
  }

  void _clearGeofences() async {
    await NativeGeofenceManager.instance.removeAllGeofences();
    await _fetchRegisteredGeofences();
  }

  void _createGeofence() async {
    try {
      await NativeGeofenceManager.instance.createGeofence(
        Geofence(
          id: _nameController.text.replaceAll(' ', '_'),
          location: Location(
            latitude: double.parse(_latController.text),
            longitude: double.parse(_lonController.text),
          ),
          radiusMeters: double.parse(_radiusController.text),
          triggers: {GeofenceEvent.enter},
          androidSettings: AndroidGeofenceSettings(
            initialTriggers: {GeofenceEvent.enter},
          ),
          iosSettings: IosGeofenceSettings(),
        ),
        geofenceTriggered,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Geofence created successfully')),
      );

      await _fetchRegisteredGeofences();
    } on NativeGeofenceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: _clearGeofences, icon: Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .center,
          spacing: 12,
          children: [
            Text(
              'Currently registered geofences: ${_geofences.isEmpty ? 'none' : _geofences.map((g) => g.id).join(', ')}',
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _latController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Latitude',
              ),
            ),
            TextField(
              controller: _lonController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Longitude',
              ),
            ),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Radius (meters)',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGeofence,
        tooltip: 'Create Geofence',
        child: const Icon(Icons.add),
      ),
    );
  }
}
