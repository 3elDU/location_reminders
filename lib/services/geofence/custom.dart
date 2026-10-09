import 'package:location_reminders/models/geofence.dart';
import 'package:location_reminders/services/geofence/backend.dart';

/// Custom geofencing implementation that doesn't rely on google mobile services,
/// and can work on degoogled phones.
class CustomGeofenceProvider implements GeofencingProvider {
  @override
  Future<void> createGeofence(Geofence model) {
    // TODO: implement createGeofence
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> removeGeofence(Geofence model) {
    // TODO: implement removeGeofence
    throw UnimplementedError();
  }
}
