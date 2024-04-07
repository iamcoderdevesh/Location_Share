import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';

import 'location_callback_handler.dart';
import 'location_service_repository.dart';

class BackgroundLocation {
  ReceivePort port = ReceivePort();

  String logStr = '';
  late bool isRunning;
  late LocationDto lastLocation;

  void initState() {
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  Future<void> updateUI(dynamic data) async {
    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;
    await _updateNotificationText(locationDto!);

    // setState(() {
    if (data != null) {
      lastLocation = locationDto;
    }
    // });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    // await BackgroundLocator.updateNotificationText(
    //     title: "new location received",
    //     msg: "${DateTime.now()}",
    //     bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();

    isRunning = _isRunning;

    print('Running ${isRunning.toString()}');
  }

  // @override
  // Widget build(BuildContext context) {
  //   String msgStatus = "-";
  //   if (isRunning != null) {
  //     if (isRunning) {
  //       msgStatus = 'Is running';
  //     } else {
  //       msgStatus = 'Is not running';
  //     }
  //   }
  //   final status = Text("Status: $msgStatus");
  // }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    // setState(() {
    isRunning = _isRunning;
    // });
  }

  void onStart() async {
    // if (await _checkLocationPermission()) {
    await _startLocator();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    // setState(() {
    isRunning = _isRunning;
    // });
    // } else {
    // show error
    // }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: const IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: 0,
            stopWithTerminate: true),
        autoStop: false,
        androidSettings: const AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 300,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Location Service Running',
                notificationMsg: 'Tracking location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-to-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }
}
