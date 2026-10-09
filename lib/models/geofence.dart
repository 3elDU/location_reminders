import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/services/database.dart';

class Geofence {
  Geofence.empty(DatabaseService database)
    : id = database.getNextGeofenceId(),
      radius = 150,
      location = Location(latitude: 0, longitude: 0, description: '');

  String id;
  double radius;
  Location location;
}
