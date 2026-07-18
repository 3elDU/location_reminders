import 'package:drift/drift.dart' hide Column;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location_reminders/components/create_card.dart';
import 'package:location_reminders/components/note.dart';
import 'package:location_reminders/deeplink/notification_page.dart';
import 'package:location_reminders/geocoding_service.dart';
import 'package:location_reminders/models/pending_note_model.dart';
import 'package:location_reminders/pages/debug.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:location_reminders/pages/reminder_details.dart';
import 'package:location_reminders/reminders_service.dart';
import 'package:native_geofence/native_geofence.dart' hide Location;
import 'package:permission_handler/permission_handler.dart';
import 'package:location_reminders/database.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorGlobalKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request location permission
  await Permission.location.request();
  await Permission.locationAlways.request();

  // request notification permission
  final plugin = FlutterLocalNotificationsPlugin();
  plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()!
      .requestNotificationsPermission();

  await NativeGeofenceManager.instance.initialize();

  final database = AppDatabase();
  runApp(RemindersApp(database: database));
}

class RemindersApp extends StatefulWidget {
  const RemindersApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<RemindersApp> createState() => _RemindersAppState();
}

class _RemindersAppState extends State<RemindersApp> {
  late final RemindersService _remindersService;

  @override
  void initState() {
    super.initState();

    _remindersService = RemindersService(widget.database);
    _registerNotificationCallbacks();
    _processAppLaunchDetails();
  }

  // if the app was launched by user pressing a notification, immediately push
  // the notification details route
  void _processAppLaunchDetails() async {
    final launchDetails = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    // Immediately push notification details route, if app was launched through a notification
    final deeplink = NotificationPageDeeplink.tryFromPayload(
      launchDetails?.notificationResponse?.payload,
    );
    if (deeplink == null) return;

    _openReminderDetails(deeplink.geofenceId);
  }

  // those callbacks will be fired if notification is tapped while the app is running
  void _registerNotificationCallbacks() async {
    await FlutterLocalNotificationsPlugin().initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (details) {
        final deeplink = NotificationPageDeeplink.tryFromPayload(
          details.payload,
        );
        if (deeplink == null) return;

        _openReminderDetails(deeplink.geofenceId);
      },
    );
  }

  void _openReminderDetails(String geofenceId) async {
    final reminder = await _remindersService.find(geofenceId);
    if (reminder == null || !mounted) return;

    // post frame callback needed here because the widget isn't mounted yet at this point
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ReminderDetailsPage.show(reminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MultiProvider(
        providers: [
          Provider.value(value: _remindersService),
          Provider.value(value: GeocodingService()),
          ChangeNotifierProvider(create: (_) => PendingNoteModel()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorGlobalKey,
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
          home: HomePage(
            title: 'Location Reminders',
            database: widget.database,
          ),
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
    final location = await LocationPickerPage.pick();

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
