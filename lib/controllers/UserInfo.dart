import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:location_share/state/state.dart';
import 'package:location_share/utils/utils.dart';

class UserInfoHandler {
  final LocationShareProvider state;
  final String _shareCode = DateTime.now().millisecondsSinceEpoch.toString();
  final String color = Utils().generateRandomColor();

  UserInfoHandler(this.state);

  Future<void> handleUserInfo() async {
    Map<String, String>? deviceInfo = await Utils().getDeveiceInfo();
    if (deviceInfo["status"] == "true") {
      state.setUserInfo(
          userName: deviceInfo["host"]!,
          user_id: deviceInfo["id"]!,
          userEmail: "test@mail.com",
          locationStatus: state.locationStatus,
          backgroundStatus: state.backgroundStatus,
          color: color,
          shareCode: _shareCode,
          updateInterval: state.locInterval);
    }

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
            locationStatus: snapshot.data()!['locStatus'],
            backgroundStatus: snapshot.data()!['backgroundStatus'],
            shareCode: snapshot.data()!['share_code'],
            color: snapshot.data()!['color'],
            updateInterval: snapshot.data()!['locInterval']);
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
        'locStatus': state.locationStatus,
        'backgroundStatus': state.backgroundStatus,
        'locInterval': state.locInterval,
        'color': color,
        'joined_on': DateTime.now().millisecondsSinceEpoch,
      });
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

  Future<bool> updateLocInterval() async {
    try {
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(state.user_id)
          .update({'locUpdateInterval': state.locInterval});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLocStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(state.user_id)
          .update({'locStatus': state.locationStatus, 'backgroundStatus': state.backgroundStatus});
      return true;
    } catch (e) {
      return false;
    }
  }
}
