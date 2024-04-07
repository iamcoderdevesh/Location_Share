import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';
import 'package:location_share/controllers/Location.dart';

class UpdateLocation {
  final LocationShareProvider state;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  UpdateLocation(this.state);

  void initState() {
    if (state.locationStatus) {
      try {
        _locationSubscription =
            location.onLocationChanged.handleError((dynamic err) {
          _locationSubscription?.cancel();
        }).listen((loc.LocationData newLoc) async {
          await LocationInfo().updateLocationInFirebase(
              latitude: newLoc.latitude, longitude: newLoc.longitude);
        });
      } catch (e) {
        print(e);
      }
    }
    return;
  }

  void onStop() {
    _locationSubscription?.cancel();
  }
}
