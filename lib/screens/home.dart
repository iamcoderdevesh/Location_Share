import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:animated_location_indicator/animated_location_indicator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:location_share/controllers/Share.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/widgets/bottomSheetModal.dart';
import 'package:provider/provider.dart';
import '../widgets/location_marker.dart';
import '../widgets/map_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mapController = MapController();
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('loc').snapshots();
  final loc.Location location = loc.Location();

  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  loc.LocationData? currentLocation;
  bool isLoading = true;
  late List pairsList = [];
  List<Marker> markersList = [];
  StreamSubscription<loc.LocationData>? _locationSubscription;

  void updateMyLocation() {
    location.getLocation().then(
      (location) {
        currentLocation = location;
        isLoading = false;
        setState(() {});
      },
    );

    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription?.cancel();
    }).listen((loc.LocationData newLoc) async {
      currentLocation = newLoc;
      await FirebaseFirestore.instance.collection('loc').doc(state.user_id).set(
          {'latitude': newLoc.latitude, 'longitude': newLoc.longitude},
          SetOptions(merge: true));
    });
  }

  @override
  void initState() {
    super.initState();
    updateMyLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: Text("Loading"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _locStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading"),
                  );
                }
                if (snapshot.hasData) {
                  getMarkers(snapshot.data!);
                }
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    interactionOptions: const InteractionOptions(
                      enableMultiFingerGestureRace: true,
                    ),
                    initialCenter: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    initialZoom: 14.5,
                    minZoom: 2.0, // Minimum zoom level
                    maxZoom: 22.0, // Maximum zoom level
                    onMapReady: () async {
                      pairsList = await ShareInfo(state, "").getShareInfo();
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
                            acquireUserLocation,
                            _mapController,
                            context.watch<LocationShareProvider>().shareCode,
                            pairsList),
                      ),
                    ),
                    MarkerLayer(markers: markersList),
                  ],
                );
              },
            ),
    );
  }

  void getMarkers(QuerySnapshot snapshot) async {
    List<Marker> newMarkers = [];
    for (var document in snapshot.docs) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      DocumentSnapshot pairsInfo = await FirebaseFirestore.instance
          .collection('pairs')
          .doc(document.id)
          .get();
      if (pairsInfo.exists && pairsInfo.id != state.user_id) {
        Map<String, dynamic> pairsData =
            pairsInfo.data()! as Map<String, dynamic>;
        if (pairsData.values.contains(true)) {

          final userInfo = await getUserNameAndId(document.id);
          String userAddress = await getUserAddress(LatLng(data['latitude'], data['longitude']));

          Marker marker = customMarker(
              LatLng(data['latitude'], data['longitude']),
              userInfo?['user_logo'],
              userInfo?['user_name'], userAddress);
          newMarkers.add(marker);
        }
      }
    }
    setState(() {
      markersList = newMarkers;
    });
  }

  Marker customMarker(LatLng position, String logo, String userName, String userAddress) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: position,
      child: GestureDetector(
        onTap: () {
          bottomSheetModal(
            context,
            locationInfoPopover(userName, userAddress),
          );
        },
        child: CustomMarker(initial: logo),
      ),
    );
  }

  Popover locationInfoPopover(String userName, String userAddress) {
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          userName,
                          style: const TextStyle(
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
                Expanded(
                  child: Text(
                    userAddress,
                    softWrap: true,
                    style: const TextStyle(
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

  Future<loc.LocationData?> acquireUserLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      } else {
        updateMyLocation();
      }
    } else {
      updateMyLocation();
    }

    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserNameAndId(String userId) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users_info').doc(userId);
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      return {
        'id': snapshot.data()!['id'],
        'user_logo': snapshot.data()!['name'].toString().substring(0, 1),
        'user_name': snapshot.data()!['name'],
        'status': snapshot.data()!['status'],
      };
    }
    return null;
  }

  Future<String> getUserAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return "${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    
  }
}
