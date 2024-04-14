import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:animated_location_indicator/animated_location_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_share/controllers/Share.dart';
import 'package:location_share/services/locationService.dart';
import 'package:location_share/services/ttsService.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/utils/utils.dart';
import 'package:location_share/widgets/bottomSheetModal.dart';
import 'package:provider/provider.dart';
import '../widgets/location_marker.dart';
import '../widgets/map_overlay.dart';
import 'package:location/location.dart' as loc;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mapController = MapController();
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('loc').snapshots();
  late LocationSettings locationSettings;
  late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
  final loc.Location location = loc.Location();
  loc.LocationData? currentLocation;
  bool isLoading = true;
  late List pairsList = [];
  List<Marker> markersList = [];
  LatLng defaultPosition = const LatLng(19.074, 72.889);
  late FlutterTtsService _flutterTtsService;

  void updateMyLocation() async {
    // ignore: use_build_context_synchronously
    final position = await Utils().acquireUserLocation(context);

    if (position != null) {
      if (defaultPosition == const LatLng(19.074, 72.889)) {
        defaultPosition =
            LatLng(position.latitude as double, position.longitude as double);
        setState(() {
          _mapController.move(
            defaultPosition,
            16,
          );
        });
      }
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    updateMyLocation();
    UpdateLocation(state).initState();
    _flutterTtsService = FlutterTtsService(state);
    _flutterTtsService.initTts();
  }

  @override
  void dispose() {
    _mapController.dispose();
    // _locationSubscription?.cancel();
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
              child: CircularProgressIndicator(),
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
              initialCenter: currentLocation != null
                  ? LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!)
                  : const LatLng(19.074, 72.889),
              initialZoom: 14.5,
              minZoom: 2.0,
              maxZoom: 22.0,
              onMapReady: () async {
                pairsList = await ShareInfo(state).getShareInfo();
                setState(() {
                  _mapController.move(
                    defaultPosition,
                    16,
                  );
                });
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
      if (pairsInfo.exists && pairsInfo.id != state.user_id) {
        Map<String, dynamic> pairsData =
            pairsInfo.data()! as Map<String, dynamic>;
        if (pairsData.values.contains(true)) {
          final userInfo = await getUserNameAndId(document.id);
          bool status = userInfo?['status'];
          if (status == true) {
            String userAddress = await Utils()
                .getUserAddress(LatLng(data['latitude'], data['longitude']));

            String timestamp = data['updatedAt'] != null
                ? Utils().getFormatedTimeStamp(
                    timestamp:
                        DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
                            .toString(), isTimeInHM: true)
                : "Just Now";

            Marker marker = customMarker(
                LatLng(data['latitude'], data['longitude']),
                userInfo?['user_logo'],
                userInfo?['user_name'],
                userInfo?['color'],
                userAddress,
                timestamp.toString());
            newMarkers.add(marker);
          }
        }
      }
    }
    setState(() {
      markersList = newMarkers;
    });
  }

  Marker customMarker(LatLng position, String logo, String userName,
      String color, String userAddress, String timestamp) {
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
          _mapController.move(
            position,
            16,
          );
        },
        child: CustomMarker(initial: logo, color: color),
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
                          // Text(
                          //   "0 km away",
                          //   style: TextStyle(
                          //     color: Colors.grey[500],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 8,
                          // ),
                          // Text(
                          //   "•",
                          //   style: TextStyle(
                          //     color: Colors.grey[500],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 8,
                          // ),
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
            FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                await _flutterTtsService.speak(text: userAddress);
              },
              child: Icon(Icons.graphic_eq,
                  color: Theme.of(context).colorScheme.onInverseSurface),
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
        'color': snapshot.data()!['color'],
        'status': snapshot.data()!['locStatus'],
      };
    }
    return null;
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
