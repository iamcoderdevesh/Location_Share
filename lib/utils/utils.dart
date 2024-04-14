import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';
import 'package:location/location.dart' as loc;
import 'package:device_info_plus/device_info_plus.dart';

class Utils {
  Utils();

  String getFormatedTimeStamp(
      {required String timestamp, bool isTimeInHM = false}) {
    // Create a DateFormat
    var format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");

    // Parse the date string into a DateTime object
    DateTime date = format.parse(timestamp);

    // Get the current date and time in the local timezone
    DateTime now = DateTime.now();

    // Convert both the current time and the timestamp to UTC
    date = date.toUtc();
    now = now.toUtc();

    // Get the time ago
    String updatedAt;
    if (isTimeInHM) {
      DateTime date = format.parse(timestamp);
      updatedAt = DateFormat('hh:mm a').format(date);
    } else {
      if (now.difference(date).inMinutes < 1) {
        updatedAt = "Just Now";
      } else {
        updatedAt = timeago.format(date, locale: 'en_short') + " ago";
      }
    }
    return updatedAt;
  }

  String generateRandomColor() {
    Random random = Random();

    int red;
    int green;
    int blue;

    // Ensure at least one color channel has a value greater than 127
    do {
      red = random.nextInt(256);
      green = random.nextInt(256);
      blue = random.nextInt(256);
    } while (red < 128 && green < 128 && blue < 128);

    String colorString = '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';

    return colorString;
  }

  Future<loc.LocationData?> acquireUserLocation(BuildContext context) async {
    final loc.Location location = loc.Location();
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
      }
    }

    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<String> getUserAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    String? place_street = place.street == place.name
        ? place.name
        : '${place.street}, ${place.name}';

    String placeDetails = "";
    placeDetails +=
        place_street != null && place_street.isNotEmpty ? place_street : "";
    placeDetails += place.subLocality != null && place.subLocality!.isNotEmpty
        ? ", ${place.subLocality}"
        : "";
    placeDetails += place.locality != null && place.locality!.isNotEmpty
        ? ", ${place.locality}"
        : "";
    placeDetails +=
        place.administrativeArea != null && place.administrativeArea!.isNotEmpty
            ? ", ${place.administrativeArea}"
            : "";
    placeDetails += place.thoroughfare != null && place.thoroughfare!.isNotEmpty
        ? ", ${place.thoroughfare}"
        : "";
    placeDetails +=
        place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty
            ? ", ${place.subThoroughfare}"
            : "";
    placeDetails += place.country != null && place.country!.isNotEmpty
        ? ", ${place.country}"
        : "";

    return placeDetails;
  }

  Future<Map<String, String>> getDeveiceInfo() async {
    try {
      late AndroidDeviceInfo androidInfo;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      androidInfo = await deviceInfo.androidInfo;
      return {
        "host": androidInfo.host.toString(),
        "id": androidInfo.id.toString(),
        "status": "true"
      };
    } catch (e) {
      return {"status": "false"};
    }
  }
}
