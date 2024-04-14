import 'package:flutter/material.dart';
import 'package:location_share/themes/theme.dart';

class LocationShareProvider extends ChangeNotifier {
  late ThemeData _themeData;

  String user_id = '',
      userName = '',
      userEmail = '',
      shareCode = '',
      color = '',
      locInterval = '',
      theme = 'sys';
  bool locationStatus = false, backgroundStatus = false;
  String? language = 'hi-IN', engine = null;
  double pitch = 1.0, rate = 0.5, volume = 1.0;

  LocationShareProvider({this.userName = '', this.user_id = '', this.locationStatus = false});

  ThemeData get themeData => _themeData;

  void setUserInfo({
    required String userName,
    required String user_id,
    required String userEmail,
    required bool locationStatus,
    required bool backgroundStatus,
    required String shareCode,
    required String color,
    required String updateInterval,
  }) async {
    this.user_id = user_id;
    this.userName = userName;
    this.userEmail = userEmail;
    this.shareCode = shareCode;
    this.color = color;
    this.locationStatus = locationStatus;
    this.backgroundStatus = backgroundStatus;
    locInterval = updateInterval;
    notifyListeners();
  }

  void setLocationStatus({required bool status}) {
    locationStatus = status;
    notifyListeners();
  }

  void setBackgroundStatus({required bool status}) {
    backgroundStatus = status;
    notifyListeners();
  }

  void setUpdateInterval({required String updateInterval}) {
    locInterval = updateInterval;
    notifyListeners();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
  }

  void toggleTheme({required String mode, String? isSys}) {
    if (mode == 'dark' && isSys == null) {
      theme = mode;
      themeData = darkTheme;
    } else if (mode == 'light' && isSys == null) {
      theme = mode;
      themeData = lightTheme;
    } else {
      themeData = mode == 'light' ? lightTheme : darkTheme;
      theme = isSys!;
    }

    notifyListeners();
  }

  void setTtsSettings({String language = '', String engine = '', double volume = 0.5, double pitch = 1.0, double rate = 0.5 }) {
    this.language = language;
    this.engine = engine;
    this.volume = volume;
    this.pitch = pitch;
    this.rate = rate;
    notifyListeners();
  }
}