import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location_reminders/components/create_card.dart';
import 'package:location_reminders/components/note.dart';
import 'package:location_reminders/deeplink/notification_page.dart';
import 'package:location_reminders/models/reminder_handle.dart';
import 'package:location_reminders/pages/welcome.dart';
import 'package:location_reminders/services/geocoding.dart';
import 'package:location_reminders/models/pending_reminder.dart';
import 'package:location_reminders/models/reminder_list.dart';
import 'package:location_reminders/pages/debug.dart';
import 'package:location_reminders/pages/location_picker.dart';
import 'package:location_reminders/pages/reminder_details.dart';
import 'package:location_reminders/services/database.dart';
import 'package:location_reminders/services/geofence/backend.dart';
import 'package:location_reminders/database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorGlobalKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final geoBackend = GeofencingBackend();
  final geofencing = (await geoBackend.readGeofencePreference()).implementation;
  await geofencing.init();

  final database = AppDatabase();

  runApp(RemindersApp(database: database, geofencing: geofencing));
}

class RemindersApp extends StatefulWidget {
  const RemindersApp({
    super.key,
    required this.database,
    required this.geofencing,
  });

  final AppDatabase database;
  final GeofencingProvider geofencing;

  @override
  State<RemindersApp> createState() => _RemindersAppState();
}

class _RemindersAppState extends State<RemindersApp> {
  late final DatabaseService _database;
  final _sharedPrefs = SharedPreferencesAsync();

  Future<bool?> get onboardingCompleted =>
      _sharedPrefs.getBool('onboardingCompleted');

  @override
  void initState() {
    super.initState();

    onboardingCompleted.then((completed) async {
      if (completed == true) return;

      bool? allGranted;
      while (allGranted != true) {
        allGranted = await WelcomePage.show();
      }

      await _sharedPrefs.setBool('onboardingCompleted', true);
      navigatorGlobalKey.currentState!.push(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });

    _database = DatabaseService(
      database: widget.database,
      geofencing: widget.geofencing,
    );

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
    final reminder = await _database.findReminder(geofenceId);
    if (reminder == null || !mounted) return;

    // post frame callback needed here because the widget isn't mounted yet at this point
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReminderDetailsPage.show(
        ReminderHandle(
          reminder: reminder,
          list: context.read<ReminderListModel>(),
          database: _database,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MultiProvider(
        providers: [
          Provider.value(value: _database),
          Provider.value(value: GeocodingService()),
          ChangeNotifierProvider(create: (_) => ReminderListModel(_database)),
          ChangeNotifierProvider<PendingReminderModel>(
            create: (context) => PendingReminderModel(
              _database,
              list: context.read<ReminderListModel>(),
            ),
          ),
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

  void _completeReminder(Reminder reminder) async {
    await context.read<DatabaseService>().complete(reminder);
  }

  void _createNewNote() async {
    final location = await LocationPickerPage.pick();

    if (location == null || !mounted) return;
    context.read<PendingReminderModel>().startCreation(location);
  }

  void _cancelNoteCreation() {
    context.read<PendingReminderModel>().cancelCreation();
  }

  void _finishNoteCreation() async {
    context.read<PendingReminderModel>().finishCreation();
  }

  Widget _buildReminderCard(
    ReminderListModel model,
    int index, {
    bool dismissible = true,
  }) {
    final reminder = model.list[index];
    final card = NoteCard(
      reminder,
      key: ValueKey(reminder.id),
      onTap: () {
        ReminderDetailsPage.show(model.getHandle(index));
      },
    );

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

  String _buildFilterChipLabel(
    Map<ReminderState, int> counts,
    String label,
    ReminderState type,
  ) {
    final count = counts[type];
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

    final reminders = context.watch<ReminderListModel>();

    final zeroReminders = reminders.counts.entries.every((el) => el.value == 0);
    final emptyState =
        !creatingReminder &&
        zeroReminders &&
        reminders.filter == .active &&
        !reminders.searchQueryPresent;

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
                        onChanged: (query) => reminders.setSearchQuery(query),
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
                                    reminders.setSearchQuery('');
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
                          label: Text(
                            _buildFilterChipLabel(
                              reminders.counts,
                              'Active',
                              .active,
                            ),
                          ),
                          selected: reminders.filter == .active,
                          onSelected: (_) => setState(() {
                            reminders.setFilter(.active);
                          }),
                        ),
                        ChoiceChip(
                          label: Text(
                            _buildFilterChipLabel(
                              reminders.counts,
                              'Completed',
                              .completed,
                            ),
                          ),
                          selected: reminders.filter == .completed,
                          onSelected: (_) => setState(() {
                            reminders.setFilter(.completed);
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: !creatingReminder && reminders.list.isEmpty
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
                            itemCount: reminders.loading
                                ? 0
                                : (creatingReminder
                                      // all this index trickery needed because a new reminder creation widget is also part of list view
                                      ? reminders.list.length + 1
                                      : reminders.list.length),
                            itemBuilder: (context, index) {
                              // allow reminders to be swiped only when filtering by active
                              final dismissible = reminders.filter == .active;

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
                                reminders,
                                creatingReminder ? index - 1 : index,
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
