import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_reminders/geocoding_service.dart';
import 'package:provider/provider.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  static Future<Location?> pick(BuildContext context) async {
    return Navigator.of(
      context,
    ).push<Location>(MaterialPageRoute(builder: (_) => LocationPickerPage()));
  }

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

enum PickerState { empty, searchingLocation, locationSelected }

class _LocationPickerPageState extends State<LocationPickerPage> {
  final _mapController = MapController();
  final _searchController = SearchController();

  PickerState _state = PickerState.empty;
  List<Placemark> _searchResults = [];
  Location? _selected;

  Future<void> searchLocation(String query) async {
    final places = await context.read<GeocodingService>().autocomplete(query);

    setState(() {
      _state = .searchingLocation;
      _searchResults = places
          .where(
            (loc) =>
                loc.street != null &&
                loc.locality != null &&
                loc.country != null,
          )
          .toList();
    });
  }

  void selectLocation(Placemark place) async {
    final location = await context.read<GeocodingService>().locationFromAddress(
      place.street!,
    );
    if (location == null) return;

    setState(() {
      _selected = location;
      _state = .locationSelected;
    });

    _searchController.text = place.street!;
    _mapController.move(LatLng(location.latitude, location.longitude), 16);
  }

  void selectPoint(LatLng point) {
    setState(() {
      _selected = Location(
        latitude: point.latitude,
        longitude: point.longitude,
      );
      _state = .locationSelected;
    });

    _searchController.text =
        "${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}";
  }

  void confirmLocation() {
    Navigator.of(context).pop(_selected!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick a Location')),
      body: Stack(
        alignment: .bottomCenter,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all ^ InteractiveFlag.rotate,
              ),
              initialCenter: LatLng(
                51.509364,
                -0.128928,
              ), // Center the map over London, UK
              initialZoom: 9.2,
              onTap: (_, point) => selectPoint(point),
            ),
            children: [
              TileLayer(
                // Bring your own tiles
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                userAgentPackageName:
                    'cc.petafloppa.location_reminders', // Add your app identifier
                // And many more recommended properties!
              ),
              if (_state == .locationSelected)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_selected!.latitude, _selected!.longitude),
                      child: FlutterLogo(),
                    ),
                  ],
                ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                mainAxisAlignment: .end,
                crossAxisAlignment: .stretch,
                spacing: 12,
                children: [
                  if (_state == .searchingLocation && _searchResults.isNotEmpty)
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(32),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) => ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(_searchResults[index].street ?? 'N/A'),
                            subtitle: Text(
                              "${_searchResults[index].locality}, ${_searchResults[index].country}",
                            ),
                            onTap: () {
                              selectLocation(_searchResults[index]);
                            },
                          ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: _searchResults.length,
                        ),
                      ),
                    ),
                  if (_state == .locationSelected)
                    Align(
                      alignment: .bottomRight,
                      child: FloatingActionButton(
                        onPressed: confirmLocation,
                        tooltip: 'Confirm',
                        child: Icon(Icons.check),
                      ),
                    ),
                  SearchBar(
                    controller: _searchController,
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16),
                    ),
                    constraints: BoxConstraints(minHeight: 64),
                    leading: Icon(Icons.search),
                    hintText: 'Type a location',
                    onTap: () {
                      setState(() {
                        _state = .searchingLocation;
                      });
                    },
                    onChanged: searchLocation,
                    trailing: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _state = .empty;
                            });
                            _searchController.clear();
                            _searchResults = [];
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
