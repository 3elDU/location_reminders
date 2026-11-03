import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/models/pending_reminder.dart';
import 'package:location_reminders/services/geofence/backend.dart';
import 'package:uuid/uuid.dart';

/// Abstracts away database management and geofence creation
class DatabaseService {
  final AppDatabase database;
  final GeofencingProvider? geofencing;

  DatabaseService({required this.database, this.geofencing});

  Future<Geofence> _createGeofence(PendingReminderModel model) async {
    final geofence = await database
        .into(database.geofences)
        .insertReturning(
          GeofencesCompanion.insert(
            geofenceId: model.geofence.id,
            placeDescription: model.location.description,
            latitude: model.location.latitude,
            longitude: model.location.longitude,
            radius: model.radius,
          ),
        );

    await geofencing?.createGeofence(model.geofence);

    return geofence;
  }

  String getNextGeofenceId() {
    return Uuid().v7();
  }

  Future<Reminder> create(PendingReminderModel model) async {
    debugPrint('Creating a geofence with ${model.radius}m radius');

    final geofence = await _createGeofence(model);
    final reminder = await database
        .into(database.reminders)
        .insertReturning(
          RemindersCompanion.insert(
            placeDescription: model.location.description,
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

    if (states.isNotEmpty) {
      query.where((r) => r.state.isInValues(states));
    }

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
  Future<Location> getLocation(Reminder reminder) async {
    final geofence = await findGeofenceById(reminder.geofenceId);
    return Location(
      latitude: geofence!.latitude,
      longitude: geofence.longitude,
      description: geofence.placeDescription,
    );
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
