import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';
import 'package:location/location.dart' as loc;

class Utils {
  Utils();

  String getFormatedTimeStamp({required String timestamp}) {
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
    if (now.difference(date).inMinutes < 1) {
      updatedAt = "Just Now";
    } else {
      updatedAt = timeago.format(date, locale: 'en_short') + " ago";
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
    return "${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
  }
}
