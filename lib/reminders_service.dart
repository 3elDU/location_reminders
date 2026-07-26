import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:location_reminders/callback.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/models/pending_note_model.dart';
import 'package:native_geofence/native_geofence.dart';

class RemindersService {
  final AppDatabase database;

  RemindersService(this.database);

  Future<void> _createGeofence(String geofenceId, PendingNoteModel model) {
    return NativeGeofenceManager.instance.createGeofence(
      Geofence(
        id: geofenceId,
        location: Location(
          latitude: model.location!.latitude,
          longitude: model.location!.longitude,
        ),
        radiusMeters: model.radius,
        triggers: {.enter},
        androidSettings: AndroidGeofenceSettings(
          initialTriggers: {GeofenceEvent.enter},
        ),
        iosSettings: IosGeofenceSettings(),
      ),
      geofenceTriggered,
    );
  }

  Future<Reminder> create(PendingNoteModel model) async {
    final geofenceId = "zone_${await database.reminders.count().getSingle()}";

    debugPrint('Creating a geofence with ${model.radius}m radius');

    await _createGeofence(geofenceId, model);

    final reminder = await database
        .into(database.reminders)
        .insertReturning(
          RemindersCompanion.insert(
            placeDescription: model.location!.description,
            onetime: model.onetime,
            geofenceId: geofenceId,
            title: model.title,
            note: model.note,
            state: .active,
          ),
        );

    return reminder;
  }

  /// Count all reminders in the system, grouped by category
  Future<Map<ReminderState, int>> counts() async {
    final map = <ReminderState, int>{};

    await database
        .customSelect(
          'select state, count(id) as count from reminders group by state',
        )
        .map((row) {
          final state = ReminderState.values.byName(row.read<String>('state'));
          final count = row.read<int>('count');

          map[state] = count;
        })
        .get();

    return map;
  }

  /// Get all reminders matching the query
  Future<List<Reminder>> query({
    List<ReminderState> states = const [.active],
    String? search,
  }) {
    final query = database.reminders.select();

    query.where((r) => r.state.isInValues(states));

    if (search != null) {
      query.where((r) => r.title.like('%$search%') | r.note.like('%$search%'));
    }

    return query.get();
  }

  /// Find a reminder, given the native geofence id
  Future<Reminder?> find(String geofenceId) async {
    return (database.select(
      database.reminders,
    )..where((r) => r.geofenceId.equals(geofenceId))).getSingleOrNull();
  }

  /// Extract geolocation of note from the native geofence
  Future<Location> getLocation(Reminder reminder) async {
    final allGeofences = await NativeGeofenceManager.instance
        .getRegisteredGeofences();

    return allGeofences.firstWhere((g) => g.id == reminder.geofenceId).location;
  }

  /// Mark a reminder completed
  Future<Reminder> complete(Reminder reminder) async {
    reminder = reminder.copyWith(state: .completed);
    await database.reminders.replaceOne(reminder);
    return reminder;
  }

  /// Mark reminder as active again
  Future<Reminder> uncomplete(Reminder reminder) async {
    reminder = reminder.copyWith(state: .active);
    await database.reminders.replaceOne(reminder);
    return reminder;
  }
}
