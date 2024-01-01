import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:animated_location_indicator/animated_location_indicator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:location_share/widgets/bottomSheetModal.dart';
import '../widgets/location_marker.dart';
import '../widgets/map_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
        ),
        initialCenter: const LatLng(20.5937, 78.9629),
        initialZoom: 15.0,
        minZoom: 2.0, // Minimum zoom level
        maxZoom: 22.0, // Maximum zoom level
        onMapReady: () async {
          final position = await acquireUserLocation();
          if (position != null) {
            // IMPORTANT: rebuild location layer when permissions are granted
            setState(() {
              _mapController.move(
                  LatLng(position.latitude as double,
                      position.longitude as double),
                  16);
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
          tileProvider: NetworkTileProvider(),
        ),
        // const AnimatedLocationLayer(),
        RepaintBoundary(
          child: AnimatedSwitcher(
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            child: MapOverlay(
              acquireUserLocation: acquireUserLocation,
              mapController: _mapController,
            ),
          ),
        ),
        MarkerLayer(
          markers: [
            customMarker(const LatLng(18.877927, 73.163683), 'D'),
          ],
        ),
      ],
    );
  }

  Marker customMarker(LatLng position, String initial) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: position,
      child: GestureDetector(
        onTap: () {
          bottomSheetModal(
            context,
            locationInfoPopover(),
          );
        },
        child: CustomMarker(initial: initial),
      ),
    );
  }

  Popover locationInfoPopover() {
    return Popover(
      height: 275,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Devesh Ukalkar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "0 km away",
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "•",
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Just now",
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: Text(
                    "22 A, Karade kh., Maharashtra 410220, India",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text("Directions"),
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(
              height: 1.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () {},
              child: const Text(
                "Share location with Devesh Ukalkar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

Future<LocationData?> acquireUserLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  try {
    return await location.getLocation();
  } catch (e) {
    return null;
  }
}
