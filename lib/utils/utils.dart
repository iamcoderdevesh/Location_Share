import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Utils {
  final String timestamp;

  Utils(this.timestamp);

  String getFormatedTimeStamp() {
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
}
