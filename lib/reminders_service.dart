import 'package:drift/drift.dart';
import 'package:location_reminders/callback.dart';
import 'package:location_reminders/database.dart';
import 'package:native_geofence/native_geofence.dart';

class RemindersService {
  final AppDatabase database;

  RemindersService(this.database);

  Future<Reminder> create({
    required String title,
    required String note,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final geofenceId = "zone_${await database.reminders.count().getSingle()}";

    await NativeGeofenceManager.instance.createGeofence(
      Geofence(
        id: geofenceId,
        location: Location(latitude: latitude, longitude: longitude),
        radiusMeters: radius,
        triggers: {.enter},
        androidSettings: AndroidGeofenceSettings(
          initialTriggers: {GeofenceEvent.enter},
        ),
        iosSettings: IosGeofenceSettings(),
      ),
      geofenceTriggered,
    );

    final reminder = await database
        .into(database.reminders)
        .insertReturning(
          RemindersCompanion.insert(
            geofenceId: geofenceId,
            title: title,
            note: note,
          ),
        );

    return reminder;
  }

  /// Find a reminder, given the native geofence id
  Future<Reminder?> find(String geofenceId) async {
    return (database.select(
      database.reminders,
    )..where((r) => r.geofenceId.equals(geofenceId))).getSingleOrNull();
  }

  /// Delete a specific note
  Future<void> delete(Reminder reminder) async {
    await database.delete(database.reminders).delete(reminder);
  }

  Future<void> clear() async {
    await NativeGeofenceManager.instance.removeAllGeofences();
    await database.reminders.deleteAll();
  }
}
