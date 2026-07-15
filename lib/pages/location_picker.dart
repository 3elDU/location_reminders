import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_reminders/geocoding_service.dart';
import 'package:location_reminders/models/location.dart';
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
  final _requestDebouncer = Debouncer();
  final _mapController = MapController();
  final _searchController = SearchController();

  PickerState _state = PickerState.empty;
  List<Placemark> _searchResults = [];
  Location? _selected;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _getDeviceLocation());
  }

  // get device location and move to it on the map
  void _getDeviceLocation() async {
    try {
      final snackbar = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Retrieving current location'), persist: true),
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          timeLimit: const Duration(seconds: 20),
        ),
      );

      snackbar.close();
      _mapController.move(LatLng(position.latitude, position.longitude), 16);
    } on TimeoutException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reached timeout while loading location')),
        );
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    debugPrint('_searchLocation() called');
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

  void _selectLocation(Placemark place) async {
    final location = await context.read<GeocodingService>().locationFromAddress(
      place.street!,
    );
    if (location == null) return;

    setState(() {
      _selected = Location.fromGeocodingLocation(
        location,
        description: place.street!,
      );
      _state = .locationSelected;
    });

    _searchController.text = place.street!;
    _mapController.move(LatLng(location.latitude, location.longitude), 16);
  }

  void _selectPoint(LatLng point) async {
    // set state first to show point on map, then fetch readable address
    // and update the searchbar with it
    setState(() {
      _selected = Location(
        latitude: point.latitude,
        longitude: point.longitude,
        description:
            "${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}",
      );
      _state = .locationSelected;
    });

    final address = await context.read<GeocodingService>().addressFromLocation(
      point.latitude,
      point.longitude,
    );
    if (address != null) {
      setState(() {
        _selected!.description = address;
      });
    }

    _searchController.text = _selected!.description;
  }

  void _confirmLocation() {
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
                // disable rotation
                flags: InteractiveFlag.all ^ InteractiveFlag.rotate,
              ),
              initialCenter: LatLng(
                51.509364,
                -0.128928,
              ), // Center the map over London, UK
              initialZoom: 9.2,
              onTap: (_, point) => _selectPoint(point),
            ),
            children: [
              TileLayer(
                // TODO
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
                              _selectLocation(_searchResults[index]);
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
                        onPressed: _confirmLocation,
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
                    onChanged: (query) {
                      _requestDebouncer.debounce(
                        duration: const Duration(milliseconds: 500),
                        onDebounce: () {
                          _searchLocation(query);
                        },
                      );
                    },
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
