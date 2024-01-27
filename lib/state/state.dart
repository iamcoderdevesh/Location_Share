import 'package:flutter/material.dart';

class LocationShareProvider extends ChangeNotifier {
  String user_id = '';
  final String _shareCode = DateTime.now().millisecondsSinceEpoch.toString();
  String userName = '';
  String status = '';

  LocationShareProvider(
      {this.userName = '', this.user_id = '', this.status = 'inactive'});

  void setUserInfo({
    required String userName,
    required String user_id,
    required String status,
  }) async {
    this.userName = userName;
    this.user_id = user_id;
    this.status = status;
    notifyListeners();
  }

  String get shareCode => user_id;
}
