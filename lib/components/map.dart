import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A [FlutterMap] wrapper with attributions and dark mode support
class WorldMap extends StatelessWidget {
  const WorldMap({
    super.key,
    this.controller,
    required this.initialPosition,
    this.markerPosition,
    this.onTap,
    this.attributionAlignment = .bottomRight,
  });

  final MapController? controller;
  final LatLng initialPosition;
  final LatLng? markerPosition;
  final void Function(TapPosition, LatLng)? onTap;
  final Alignment attributionAlignment;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).colorScheme.brightness == .dark;
    final tileLayer = TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'cc.petafloppa.location_reminders',
      tileDisplay: TileDisplay.instantaneous(),
    );

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        backgroundColor: darkMode
            ? const Color(0xFF1F1F1F)
            : const Color(0xFFE0E0E0),
        interactionOptions: InteractionOptions(
          // disable rotation
          flags: InteractiveFlag.all ^ InteractiveFlag.rotate,
        ),
        initialCenter: initialPosition,
        initialZoom: 16,
        onTap: onTap,
      ),
      children: [
        darkMode
            ? darkModeTilesContainerBuilder(context, tileLayer)
            : tileLayer,

        if (markerPosition != null)
          MarkerLayer(
            alignment: .topCenter,
            markers: [
              Marker(
                width: 48,
                height: 48,
                point: markerPosition!,
                child: Transform.translate(
                  offset: Offset(0, 4),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 48,
                        color: darkMode ? Colors.black : Colors.white,
                      ),
                      Icon(
                        Icons.location_on_outlined,
                        size: 48,
                        color: darkMode ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        Padding(
          padding: const EdgeInsets.all(2),
          child: Align(
            alignment: attributionAlignment,
            child: TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrlString('https://openstreetmap.org/copyright'),
            ),
          ),
        ),
      ],
    );
  }
}
