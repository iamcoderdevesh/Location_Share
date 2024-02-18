import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_share/state/state.dart';
import 'package:location_share/controllers/UserInfo.dart';

class ShareInfo {
  final LocationShareProvider state;

  ShareInfo(this.state);

  Future<String> saveShareInfo({required String code}) async {
    // ignore: use_build_context_synchronously
    Map<String, bool>? result =
        await UserInfoHandler(state).getUserIdByShareCode(shareCode: code);

    if (result != null) {
      bool dataExists = result.values.first;
      String userId = result.keys.first;

      if (dataExists) {
        try {
          await FirebaseFirestore.instance
              .collection('pairs')
              .doc(state.user_id)
              .set({userId: true}, SetOptions(merge: true));
          await FirebaseFirestore.instance
              .collection('pairs')
              .doc(userId)
              .set({state.user_id: true}, SetOptions(merge: true));

          return "Location Shared Successfully!!!";
        } catch (e) {
          print('from getUserInfo: $e');
          return "Oops Something Went Wrong. Unable to share location!!!";
        }
      } else {
        // ignore: use_build_context_synchronously
        return "Invalid Location Code";
      }
    }
    return "Oops Something Went Wrong. Unable to share location!!!";
  }

  Future<List<String>> getShareInfo() async {
    final List<String> pairsList = [];
    try {
      await FirebaseFirestore.instance
          .collection('pairs')
          .doc(state.user_id)
          .get()
          .then((value) {
        if (value.exists) {
          value.data()!.forEach((key, value) {
            pairsList.add(key);
          });
        }
      });

      return pairsList;
    } catch (e) {
      print('from getUserInfo: $e');
      return pairsList;
    }
  }
}
