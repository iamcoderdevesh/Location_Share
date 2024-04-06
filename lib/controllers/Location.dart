import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location_share/utils/utils.dart';

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

  Future<void> updateLocationInFirebase({required double? latitude, required double? longitude}) async {
    try {
      await Firebase.initializeApp();
      Map<String, String>? deviceInfo = await Utils().getDeveiceInfo();
      // final location = await Location().getLocation();
      // if (location != null) {
        await FirebaseFirestore.instance
            .collection('loc')
            .doc(deviceInfo['id'])
            .set({
          'latitude': latitude,
          'longitude': longitude,
          'updatedAt': DateTime.now().millisecondsSinceEpoch
        }, SetOptions(merge: true));
        print('success location');
      // }
    } catch (e) {
      print('from updateLocationInFirebase: $e');
    }
    print('from updateLocationInFirebase');
  }
}
