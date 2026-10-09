import 'package:location_reminders/models/geofence.dart';
import 'package:location_reminders/services/geofence/custom.dart';
import 'package:location_reminders/services/geofence/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GeofencingImplementation {
  native,
  custom;

  GeofencingProvider get implementation => switch (this) {
    native => NativeGeofenceProvider(),
    custom => CustomGeofenceProvider(),
  };
}

abstract interface class GeofencingProvider {
  /// Runs all the necessary initialization work, and starts the service
  Future<void> init();

  Future<void> createGeofence(Geofence model);
  Future<void> removeGeofence(Geofence model);
}

class GeofencingBackend {
  static const _geofencingPrefKey = 'geofenceImpl';
  late GeofencingImplementation _implementation;

  GeofencingImplementation get backendPreference => _implementation;

  void init() async {
    _implementation = await readGeofencePreference();
  }

  Future<GeofencingImplementation> readGeofencePreference() async {
    final prefs = SharedPreferencesAsync();

    final string = await prefs.getString(_geofencingPrefKey);
    if (string == null) {
      return GeofencingImplementation.native;
    }

    return GeofencingImplementation.values.byName(string);
  }
}
