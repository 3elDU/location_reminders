import 'package:geocoding/geocoding.dart';

class GeocodingService {
  final Geocoding _geo = Geocoding();

  Future<List<Placemark>> autocomplete(String query) async {
    return _geo.placemarkFromAddress(query);
  }

  Future<Location?> locationFromAddress(String query) async {
    final locations = await _geo.locationFromAddress(query);
    return locations.firstOrNull;
  }
}
