import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_share/state/state.dart';

class UserInfoHandler {
  final LocationShareProvider state;

  UserInfoHandler(this.state);

  Future<void> handleUserInfo() async {
    late AndroidDeviceInfo androidInfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;

    state.setUserInfo(
      userName: androidInfo.host!,
      user_id: androidInfo.id!,
      status: 'inactive',
    );

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
          userName: snapshot.data()!['name'],
          user_id: snapshot.data()!['id'],
          status: snapshot.data()!['status'],
        );
      } else {
        await setUserInfo();
      }
    } catch (e) {
      print('from getUserInfo: $e');
    }
  }

  Future<void> setUserInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(state.user_id)
          .set({
        'name': state.userName,
        'status': 'inactive',
        'id': state.user_id,
      });
      print('success');
    } catch (e) {
      print('Error from setUserInfo: $e');
    }
  }
}