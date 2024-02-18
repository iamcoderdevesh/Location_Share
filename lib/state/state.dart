import 'package:flutter/material.dart';

class LocationShareProvider extends ChangeNotifier {
  String user_id = '';
  String userName = '';
  String userEmail = '';
  String status = '';
  String shareCode = '';
  String color = "";

  LocationShareProvider(
      {this.userName = '', this.user_id = '', this.status = 'inactive'});

  void setUserInfo({
    required String userName,
    required String user_id,
    required String userEmail,
    required String status,
    required String shareCode,
    required String color,
  }) async {
    this.user_id = user_id;
    this.userName = userName;
    this.userEmail = userEmail;
    this.status = status;
    this.shareCode = shareCode;
    this.color = color;
    notifyListeners();
  }
}
