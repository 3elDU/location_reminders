import 'package:geocoding/geocoding.dart' as geocoding;

class Location {
  Location({
    required this.latitude,
    required this.longitude,
    required this.description,
  });
  Location.fromGeocodingLocation(
    geocoding.Location location, {
    required String description,
  }) : this(
         latitude: location.latitude,
         longitude: location.longitude,
         description: description,
       );
  double latitude;
  double longitude;
  String description;

  bool get isNotEmpty =>
      latitude != 0 && longitude != 0 && description.isNotEmpty;
}
