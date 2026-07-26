import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location_reminders/components/create_card.dart';
import 'package:location_reminders/components/note.dart';
import 'package:location_reminders/deeplink/notification_page.dart';
import 'package:location_reminders/geocoding_service.dart';
import 'package:location_reminders/models/pending_reminder.dart';
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
          ChangeNotifierProvider(create: (_) => PendingReminderModel()),
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
          home: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = SearchController();
  ReminderState _filterByState = .active;
  List<Reminder> _reminders = [];
  Map<ReminderState, int> _reminderCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    final service = context.read<RemindersService>();
    final reminders = await service.query(
      states: [_filterByState],
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
    final reminderCounts = await service.counts();

    setState(() {
      _reminders = reminders;
      _reminderCounts = reminderCounts;
    });
  }

  void _completeReminder(Reminder reminder) async {
    await context.read<RemindersService>().complete(reminder);
    _fetchReminders();
  }

  void _createNewNote() async {
    final location = await LocationPickerPage.pick();

    if (location == null || !mounted) return;
    context.read<PendingReminderModel>().startCreation(location);
  }

  void _cancelNoteCreation() {
    context.read<PendingReminderModel>().finishCreation();
  }

  void _finishNoteCreation() async {
    final model = context.read<PendingReminderModel>();
    final repository = context.read<RemindersService>();

    await repository.create(model);

    model.finishCreation();
    _fetchReminders();
  }

  Widget _buildReminderCard(Reminder reminder, {bool dismissible = true}) {
    final card = NoteCard(reminder, key: ValueKey(reminder.id));

    if (dismissible) {
      return Dismissible(
        key: ValueKey(reminder.id),
        onDismissed: (_) {
          _completeReminder(reminder);
        },
        child: card,
      );
    }

    return card;
  }

  Widget _buildEmptyState() => SizedBox.expand(
    child: Column(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        SvgPicture.asset('assets/note_stack_96.svg', width: 96, height: 96),
        Text('No Reminders', style: Theme.of(context).textTheme.headlineMedium),
        FilledButton.icon(
          icon: Icon(Icons.add),
          label: Text('Create Reminder'),
          onPressed: _createNewNote,
        ),
      ],
    ),
  );

  Widget? _buildFAB(bool emptyState, bool creatingNote, bool isValid) {
    if (emptyState) return null;

    return creatingNote
        ? FloatingActionButton(
            tooltip: 'Save note',
            onPressed: isValid ? _finishNoteCreation : null,
            child: Icon(Icons.check),
          )
        : FloatingActionButton(
            tooltip: 'Add note',
            onPressed: _createNewNote,
            child: Icon(Icons.add),
          );
  }

  String _buildFilterChipLabel(String label, ReminderState type) {
    final count = _reminderCounts[type];
    return count == null || count == 0 ? label : '$label ($count)';
  }

  @override
  Widget build(BuildContext context) {
    final creatingReminder = context.select<PendingReminderModel, bool>(
      (model) => model.creating,
    );
    final isValid = context.select<PendingReminderModel, bool>(
      (model) => model.isValid,
    );

    final zeroReminders = _reminderCounts.entries.every((el) => el.value == 0);
    final emptyState =
        !creatingReminder && zeroReminders && _filterByState == .active;

    return Scaffold(
      floatingActionButton: _buildFAB(emptyState, creatingReminder, isValid),
      body: SafeArea(
        child: emptyState
            ? _buildEmptyState()
            : Column(
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onLongPress: () => Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => DebugPage())),
                      child: SearchBar(
                        controller: _searchController,
                        onChanged: (_) => _fetchReminders(),
                        elevation: WidgetStatePropertyAll(0),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16),
                        ),
                        hintText: 'Search Reminders',
                        leading: Icon(Icons.search),
                        trailing: _searchController.text.isNotEmpty
                            ? [
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _fetchReminders();
                                  },
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(_buildFilterChipLabel('Active', .active)),
                          selected: _filterByState == .active,
                          onSelected: (_) => setState(() {
                            _filterByState = .active;
                            _fetchReminders();
                          }),
                        ),
                        ChoiceChip(
                          label: Text(
                            _buildFilterChipLabel('Postponed', .postponed),
                          ),
                          selected: _filterByState == .postponed,
                          onSelected: (_) => setState(() {
                            _filterByState = .postponed;
                            _fetchReminders();
                          }),
                        ),
                        ChoiceChip(
                          label: Text(
                            _buildFilterChipLabel('Completed', .completed),
                          ),
                          selected: _filterByState == .completed,
                          onSelected: (_) => setState(() {
                            _filterByState = .completed;
                            _fetchReminders();
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: !creatingReminder && _reminders.isEmpty
                        ? Center(
                            child: Text(
                              // different texts when searching and just browsing
                              _searchController.text.isNotEmpty
                                  ? 'No Search Results'
                                  : 'Empty List',
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            // all this index trickery needed because a new reminder creation widget is also part of list view
                            itemCount: creatingReminder
                                ? _reminders.length + 1
                                : _reminders.length,
                            itemBuilder: (context, index) {
                              // allow reminders to be swiped only when filtering by active
                              final dismissible = _filterByState == .active;

                              if (creatingReminder && index == 0) {
                                final card = CreateReminderCard(
                                  key: ValueKey('create-note-card'),
                                );

                                return dismissible
                                    ? Dismissible(
                                        key: ValueKey('create-note-card'),
                                        onDismissed: (_) =>
                                            _cancelNoteCreation(),
                                        child: card,
                                      )
                                    : card;
                              }

                              return _buildReminderCard(
                                _reminders[creatingReminder
                                    ? index - 1
                                    : index],
                                dismissible: dismissible,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
