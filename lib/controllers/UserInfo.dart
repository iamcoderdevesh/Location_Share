import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/utils/utils.dart';

class UserInfoHandler {
  final LocationShareProvider state;
  final String _shareCode = DateTime.now().millisecondsSinceEpoch.toString();
  final String color = Utils().generateRandomColor();

  UserInfoHandler(this.state);

  Future<void> handleUserInfo() async {
    late AndroidDeviceInfo androidInfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;

    state.setUserInfo(
        userName: androidInfo.host!,
        user_id: androidInfo.id!,
        userEmail: "test@mail.com",
        status: 'inactive',
        color: color,
        shareCode: _shareCode);

    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users_info')
          .doc(state.user_id);

      final snapshot = await userDoc.get().onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        return userDoc.get();
      });

      if (snapshot.exists) {
        state.setUserInfo(
          user_id: snapshot.data()!['id'],
          userName: snapshot.data()!['name'],
          userEmail: snapshot.data()!['email'],
          status: snapshot.data()!['status'],
          shareCode: snapshot.data()!['share_code'],
          color: snapshot.data()!['color'],
        );
      } else {
        await setUserInfo();
      }
    } catch (e) {
      print('from getUserInfo: $e');
    }
  }

  Future<bool> setUserInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(state.user_id)
          .set({
        'id': state.user_id,
        'name': state.userName,
        'email': state.userEmail,
        'share_code': state.shareCode,
        'status': 'inactive',
        'color': color,
        'joined_on': DateTime.now().millisecondsSinceEpoch,
      });
      print("success");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> getUserIdByShareCode(
      {required String shareCode}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users_info');
      QuerySnapshot snapshot =
          await users.where('share_code', isEqualTo: shareCode).get();

      if (snapshot.docs.isNotEmpty) {
        String userId = snapshot.docs.first.id;
        return {userId: true};
      } else {
        return {"status": false};
      }
    } catch (e) {
      print('from getUserInfo: $e');
      return {"status": false};
    }
  }
}
