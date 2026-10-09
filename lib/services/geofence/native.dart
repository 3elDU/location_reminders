import 'package:location_reminders/callback.dart';
import 'package:location_reminders/models/geofence.dart';
import 'package:location_reminders/services/geofence/backend.dart';
import 'package:native_geofence/native_geofence.dart' as native_geofence;

/// Wraps the [NativeGeofenceManager] class
class NativeGeofenceProvider implements GeofencingProvider {
  @override
  Future<void> init() async {
    await native_geofence.NativeGeofenceManager.instance.initialize();
  }

  @override
  Future<void> createGeofence(Geofence model) async {
    await native_geofence.NativeGeofenceManager.instance.createGeofence(
      native_geofence.Geofence(
        id: model.id,
        location: native_geofence.Location(
          latitude: model.location.latitude,
          longitude: model.location.longitude,
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
  }

  @override
  Future<void> removeGeofence(Geofence model) async {
    await native_geofence.NativeGeofenceManager.instance.removeGeofenceById(
      model.id,
    );
  }
}
