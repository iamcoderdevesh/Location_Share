import 'package:flutter/material.dart';

class LocationShareProvider extends ChangeNotifier {
  String user_id = '',
      userName = '',
      userEmail = '',
      shareCode = '',
      color = '',
      locInterval = '';
  bool locationStatus = false;

  LocationShareProvider(
      {this.userName = '', this.user_id = '', this.locationStatus = false});

  void setUserInfo({
    required String userName,
    required String user_id,
    required String userEmail,
    required bool locationStatus,
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
    locInterval = updateInterval;
    notifyListeners();
  }

  void setLocationStatus({required bool status}) {
    locationStatus = status;
    notifyListeners();
  }

  void setUpdateInterval({required String updateInterval}) {
    locInterval = updateInterval;
    notifyListeners();
  }
}
