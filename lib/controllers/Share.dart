import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_share/state/state.dart';

class ShareInfo {
  final LocationShareProvider state;
  final String qrResult;

  ShareInfo(this.state, this.qrResult);

  Future<String> saveShareInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('pairs')
          .doc(state.user_id)
          .set({qrResult: true}, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('pairs')
          .doc(qrResult)
          .set({state.user_id: true}, SetOptions(merge: true));

      return "Location Shared Successfully!!!";
    } catch (e) {
      print('from getUserInfo: $e');
      return "Oops Something Went Wrong. Unable to share location!!!";
    }
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
