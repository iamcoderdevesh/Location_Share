import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../controllers/Share.dart';
import '../state/state.dart';
import 'bottomSheetModal.dart';
import 'button.dart';
import 'package:location_share/widgets/location_marker.dart';

class MapOverlay extends StatefulWidget {
  final String userId;
  final List pairsList;
  final Future<LocationData?> Function() acquireUserLocation;
  final MapController mapController;

  const MapOverlay(this.acquireUserLocation, this.mapController, this.userId, this.pairsList,
      {super.key});

  @override
  _MapOverlayState createState() => _MapOverlayState();
}

class _MapOverlayState extends State<MapOverlay> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).padding + const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: SizedBox(
                    height: 20.0,
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
                        final position = await widget.acquireUserLocation();
                        if (position != null) {
                          widget.mapController.move(
                              LatLng(position.latitude as double,
                                  position.longitude as double),
                              16);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Button(
                      activeColor: Theme.of(context).colorScheme.primary,
                      activeIconColor: Theme.of(context).colorScheme.onPrimary,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      icon: Icons.person_add_alt_1_outlined,
                      iconColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      active: false,
                      onPressed: () {
                        // ignore: use_build_context_synchronously
                        bottomSheetModal(context, shareWithInfoPopover(context));
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
      child: widget.pairsList.isEmpty
          ? const Center(
            child: Text("You haven't share location with anyone"),
          )
          : Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users_info')
                      .where('id', whereIn: widget.pairsList)
                      .snapshots(includeMetadataChanges: true),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return _buildListItem(context, snapshot);
                  },
                )

                // _buildListItem(
                //   context,
                //   name: "Devesh Ukalkar",
                //   address: "22 A, Karade kh., Maharashtra 410220, India",
                //   status: "Can't see your location",
                //   logo: const CustomMarker(
                //     initial: "D",
                //     color: Colors.brown,
                //   ),
                //   icon: const Icon(Icons.chevron_right),
                // ),
                // _buildListItem(
                //   context,
                //   name: "Ganesh Ukalkar",
                //   address: "22 B, Karade kh., Maharashtra 410220, India",
                //   status: "Can see your location",
                //   logo: const CustomMarker(
                //     initial: "G",
                //     color: Colors.orangeAccent,
                //   ),
                //   icon: const Icon(Icons.chevron_right),
                // ),
                // _buildListItem(
                //   context,
                //   name: "Harsh Ukalkar",
                //   address: "22 A, Karade kh., Maharashtra 410220, India",
                //   status: "Can see your location",
                //   logo: const CustomMarker(
                //     initial: "H",
                //     color: Colors.lightBlueAccent,
                //   ),
                //   icon: const Icon(Icons.chevron_right),
                // ),
              ],
            ),
    );
  }

  Widget _buildListItem(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
      child: Column(
        children: snapshot.data!.docs.map((doc) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: CustomMarker(
                  initial: doc['name'].toString().substring(0, 1),
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc['name'],
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 200.0,
                    child: Text(
                      "22 B, Karade kh., Maharashtra 410220, India",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Can see your location",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          );
        }).toList(),
      ),
    );
  }
}