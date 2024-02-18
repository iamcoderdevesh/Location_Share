import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:animated_location_indicator/animated_location_indicator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_share/controllers/Share.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/utils/utils.dart';
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
  final Geolocator geolocator = Geolocator();
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  Position? currentLocation;
  bool isLoading = true;
  late List pairsList = [];
  List<Marker> markersList = [];
  StreamSubscription<Position>? _locationSubscription;

  void updateMyLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      currentLocation = position;
      isLoading = false;
      setState(() {});

      _locationSubscription =
          Geolocator.getPositionStream().handleError((dynamic err) {
        _locationSubscription?.cancel();
      }).listen((Position newLoc) async {
        currentLocation = newLoc;
        await FirebaseFirestore.instance
            .collection('loc')
            .doc(state.user_id)
            .set({
          'latitude': newLoc.latitude,
          'longitude': newLoc.longitude,
          'updatedAt': DateTime.now().millisecondsSinceEpoch
        }, SetOptions(merge: true));
      });
    } catch (e) {
      print(e);
    }
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _locStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );
          }
          if (snapshot.hasData) {
            getMarkers(snapshot.data!);
          }
          LatLng? initialCenter;
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              interactionOptions: const InteractionOptions(
                enableMultiFingerGestureRace: true,
              ),
              initialCenter: initialCenter ??
                  const LatLng(0, 0), // Use a default location if currentLocation is null
              initialZoom: 14.5,
              minZoom: 2.0,
              maxZoom: 22.0,
              onMapReady: () async {
                pairsList = await ShareInfo(state).getShareInfo();
                // ignore: use_build_context_synchronously
                final position = await Utils().acquireUserLocation(context);
                if (position != null) {
                  setState(() {
                    _mapController.move(
                      LatLng(position.latitude, position.longitude),
                      16,
                    );
                  });
                }
                else {
                  // ignore: use_build_context_synchronously
                  showPopup(context);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                tileProvider: NetworkTileProvider(),
              ),
              RepaintBoundary(
                child: AnimatedSwitcher(
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                  child: MapOverlay(
                    _mapController,
                    context.watch<LocationShareProvider>().shareCode,
                  ),
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
      if (pairsInfo.exists) {
        //&& pairsInfo.id != state.user_id
        Map<String, dynamic> pairsData =
            pairsInfo.data()! as Map<String, dynamic>;
        if (pairsData.values.contains(true)) {
          final userInfo = await getUserNameAndId(document.id);
          String userAddress =
              await getUserAddress(LatLng(data['latitude'], data['longitude']));

          String timestamp = data['updatedAt'] != null
              ? Utils().getFormatedTimeStamp(
                  timestamp:
                      DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
                          .toString())
              : "Just Now";

          Marker marker = customMarker(
              LatLng(data['latitude'], data['longitude']),
              userInfo?['user_logo'],
              userInfo?['user_name'],
              userAddress,
              timestamp.toString());
          newMarkers.add(marker);
        }
      }
    }
    setState(() {
      markersList = newMarkers;
    });
  }

  Marker customMarker(LatLng position, String logo, String userName,
      String userAddress, String timestamp) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: position,
      child: GestureDetector(
        onTap: () {
          bottomSheetModal(
            context,
            locationInfoPopover(userName, userAddress, timestamp),
          );
        },
        child: CustomMarker(initial: logo),
      ),
    );
  }

  Popover locationInfoPopover(
      String userName, String userAddress, String timestamp) {
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
                            timestamp,
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
              child: Text(
                "Share location with $userName",
                style: const TextStyle(
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

  void showPopup(BuildContext ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          title: const Text('Use Location?'),
          content: const Text(
              'Your Location seems to be disabled, do you want to enable it.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
