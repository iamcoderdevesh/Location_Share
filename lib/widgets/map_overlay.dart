import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'bottomSheetModal.dart';
import 'button.dart';
import 'package:location_share/widgets/location_marker.dart';

class MapOverlay extends StatelessWidget {
  final double buttonSpacing;
  final Future<LocationData?> Function() acquireUserLocation;
  final MapController mapController;

  const MapOverlay({
    Key? key,
    this.buttonSpacing = 20.0,
    required this.acquireUserLocation,
    required this.mapController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).padding + EdgeInsets.all(buttonSpacing),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: buttonSpacing,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      activeColor: Theme.of(context).colorScheme.primary,
                      activeIconColor: Theme.of(context).colorScheme.onPrimary,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      icon: Icons.gps_fixed,
                      iconColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      active: false,
                      onPressed: () async {
                        final position = await acquireUserLocation();
                        if (position != null) {
                          mapController.move(
                              LatLng(position.latitude as double,
                                  position.longitude as double),
                              16);
                        }
                      },
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    Button(
                      activeColor: Theme.of(context).colorScheme.primary,
                      activeIconColor: Theme.of(context).colorScheme.onPrimary,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      icon: Icons.person_add_alt_1_outlined,
                      iconColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      active: false,
                      onPressed: () => {
                        bottomSheetModal(context, shareWithInfoPopover(context))
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Popover shareWithInfoPopover(BuildContext context) {
    return Popover(
      child: Column(
        children: [
          _buildListItem(
            context,
            name: "Devesh Ukalkar",
            address: "22 A, Karade kh., Maharashtra 410220, India",
            status: "Can't see your location",
            logo: const CustomMarker(
              initial: "D",
              color: Colors.brown,
            ),
            icon: const Icon(Icons.chevron_right),
          ),
          _buildListItem(
            context,
            name: "Ganesh Ukalkar",
            address: "22 A, Karade kh., Maharashtra 410220, India",
            status: "Can see your location",
            logo: const CustomMarker(
              initial: "G",
              color: Colors.orangeAccent,
            ),
            icon: const Icon(Icons.chevron_right),
          ),
          _buildListItem(
            context,
            name: "Harsh Ukalkar",
            address: "22 A, Karade kh., Maharashtra 410220, India",
            status: "Can see your location",
            logo: const CustomMarker(
              initial: "H",
              color: Colors.lightBlueAccent,
            ),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required String name,
    required String address,
    required String status,
    required Widget logo,
    required Widget icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: logo,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          icon,
        ],
      ),
    );
  }
}
