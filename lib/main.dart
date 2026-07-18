import 'package:drift/drift.dart' hide Column;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location_reminders/components/create_card.dart';
import 'package:location_reminders/components/note.dart';
import 'package:location_reminders/geocoding_service.dart';
import 'package:location_reminders/models/pending_note_model.dart';
import 'package:location_reminders/pages/debug.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:location_reminders/reminders_service.dart';
import 'package:native_geofence/native_geofence.dart' hide Location;
import 'package:permission_handler/permission_handler.dart';
import 'package:location_reminders/database.dart';
import 'package:provider/provider.dart';

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

  final database = AppDatabase();
  runApp(RemindersApp(database));
}

class RemindersApp extends StatelessWidget {
  final AppDatabase database;

  const RemindersApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MultiProvider(
        providers: [
          Provider(create: (context) => RemindersService(database)),
          Provider.value(value: GeocodingService()),
          ChangeNotifierProvider(create: (_) => PendingNoteModel()),
        ],
        child: MaterialApp(
          title: 'Location Reminders',
          theme: ThemeData(
            colorScheme:
                lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.orange),
          ),
          darkTheme: ThemeData(
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.orange,
                  brightness: .dark,
                ),
          ),
          home: HomePage(title: 'Location Reminders', database: database),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.database});

  final AppDatabase database;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    final reminders = await widget.database.reminders.all().get();

    setState(() {
      _reminders = reminders;
    });
  }

  void _deleteNote(Reminder reminder) async {
    await context.read<RemindersService>().delete(reminder);
    _fetchReminders();
  }

  void _createNewNote() async {
    final location = await LocationPickerPage.pick(context);

    if (location == null || !mounted) return;
    context.read<PendingNoteModel>().startCreation(location);
  }

  void _cancelNoteCreation() {
    context.read<PendingNoteModel>().finishCreation();
  }

  void _finishNoteCreation() async {
    final model = context.read<PendingNoteModel>();
    final repository = context.read<RemindersService>();

    await repository.create(model);

    model.finishCreation();
    _fetchReminders();
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Dismissible(
      key: ValueKey(reminder.id),
      onDismissed: (_) {
        _deleteNote(reminder);
      },
      child: NoteCard(reminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creatingNote = context.select<PendingNoteModel, bool>(
      (model) => model.creating,
    );
    final isValid = context.select<PendingNoteModel, bool>(
      (model) => model.isValid,
    );
    final showNoNotesLabel = !creatingNote && _reminders.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DebugPage()),
            );
          },
          child: Text(widget.title),
        ),
      ),
      floatingActionButton: creatingNote
          ? FloatingActionButton(
              tooltip: 'Save note',
              onPressed: isValid ? _finishNoteCreation : null,
              child: Icon(Icons.check),
            )
          : FloatingActionButton(
              tooltip: 'Add note',
              onPressed: _createNewNote,
              child: Icon(Icons.add),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showNoNotesLabel
            ? Center(
                child: Text(
                  'No notes yet',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            : ListView(
                children: [
                  if (creatingNote)
                    Dismissible(
                      key: ValueKey('create-note-card'),
                      onDismissed: (_) => _cancelNoteCreation(),
                      child: CreateNoteCard(),
                    ),
                  ..._reminders.map((r) => _buildReminderCard(r)),
                ],
              ),
      ),
    );
  }
}
