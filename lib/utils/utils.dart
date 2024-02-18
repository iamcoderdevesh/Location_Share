import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';
import 'package:geolocator/geolocator.dart';

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

  Future<Position?> acquireUserLocation(BuildContext context) async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      return null;
    }
  }
}
