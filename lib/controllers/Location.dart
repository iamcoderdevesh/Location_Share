import 'package:cloud_firestore/cloud_firestore.dart';

class LocationInfo {
  LocationInfo();

  Future<Map<String, String>> getLocationInfo({required String userId}) async {
    try {
      final locDoc = FirebaseFirestore.instance.collection('loc').doc(userId);

      final snapshot = await locDoc.get().onError((error, stackTrace) {
        return locDoc.get();
      });

      if (snapshot.exists) {
        return {
          "latitude": snapshot.data()!['latitude'].toString(),
          "longitude": snapshot.data()!['longitude'].toString(),
          "updatedAt": snapshot.data()!['updatedAt'].toString(),
          "status": "true"
        };
      } else {
        return {"status": "false"};
      }
    } catch (e) {
      return {"status": "false"};
    }
  }
}
