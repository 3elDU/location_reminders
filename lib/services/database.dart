import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:location_reminders/callback.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/models/pending_reminder.dart';
import 'package:native_geofence/native_geofence.dart' as native_geofence;
import 'package:uuid/uuid.dart';

/// Abstracts away database management and geofence creation
class DatabaseService {
  final AppDatabase database;

  DatabaseService(this.database);

  Future<Geofence> _createGeofence(
    String geofenceId,
    PendingReminderModel model,
  ) async {
    final geofence = await database
        .into(database.geofences)
        .insertReturning(
          GeofencesCompanion.insert(
            geofenceId: geofenceId,
            placeDescription: model.location!.description,
            latitude: model.location!.latitude,
            longitude: model.location!.longitude,
            radius: model.radius,
          ),
        );

    await native_geofence.NativeGeofenceManager.instance.createGeofence(
      native_geofence.Geofence(
        id: geofenceId,
        location: native_geofence.Location(
          latitude: model.location!.latitude,
          longitude: model.location!.longitude,
        ),
        radiusMeters: model.radius,
        triggers: {.enter},
        androidSettings: native_geofence.AndroidGeofenceSettings(
          initialTriggers: {native_geofence.GeofenceEvent.enter},
        ),
        iosSettings: native_geofence.IosGeofenceSettings(),
      ),
      geofenceTriggered,
    );

    return geofence;
  }

  Future<Reminder> create(PendingReminderModel model) async {
    final geofenceId = Uuid().v7();

    debugPrint('Creating a geofence with ${model.radius}m radius');

    final geofence = await _createGeofence(geofenceId, model);
    final reminder = await database
        .into(database.reminders)
        .insertReturning(
          RemindersCompanion.insert(
            placeDescription: model.location!.description,
            onetime: model.onetime,
            geofenceId: geofence.id,
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
      query.where(
        (r) =>
            r.title.like('%$search%') |
            r.note.like('%$search%') |
            r.placeDescription.like('%$search%'),
      );
    }

    query.orderBy([(u) => OrderingTerm.desc(u.id)]);
    return query.get();
  }

  Future<Geofence?> findGeofence(String geofenceId) async {
    return (database.select(
      database.geofences,
    )..where((r) => r.geofenceId.equals(geofenceId))).getSingleOrNull();
  }

  Future<Geofence?> findGeofenceById(int id) async {
    return (database.select(
      database.geofences,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  /// Find a reminder, given the native geofence id
  Future<Reminder?> findReminder(String geofenceId) async {
    final geofence = await findGeofence(geofenceId);
    if (geofence == null) return null;

    return (database.select(
      database.reminders,
    )..where((r) => r.geofenceId.equals(geofence.id))).getSingleOrNull();
  }

  /// Extract geolocation of a reminder from the native geofence
  Future<native_geofence.Location> getLocation(Reminder reminder) async {
    final allGeofences = await native_geofence.NativeGeofenceManager.instance
        .getRegisteredGeofences();

    final geofence = await findGeofenceById(reminder.geofenceId);
    return allGeofences
        .firstWhere((g) => g.id == geofence!.geofenceId)
        .location;
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
