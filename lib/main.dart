import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location_share/screens/splash_screen.dart';
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/UserInfo.dart';
import 'package:location/location.dart' as loc;

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(statusBarColor: Colors.grey.shade900));
  final loc.Location location = loc.Location();
  location.enableBackgroundMode(enable: true);
  location.changeSettings(interval: 10, accuracy: loc.LocationAccuracy.high);

  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyAjgA8lmx32Pri8Cr3vTnJ9O8_Rya27GoE',
          appId: '1:626166769708:android:15fd9a9136a832523fc989',
          messagingSenderId: '626166769708',
          projectId: 'location-share-b7a37',
        ))
      : await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationShareProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    UserInfoHandler(Provider.of<LocationShareProvider>(context, listen: false))
        .handleUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    late LocationShareProvider state =
        Provider.of<LocationShareProvider>(context, listen: false);
    if (state.theme == 'sys') {
      state.toggleTheme(mode: isDarkMode ? 'dark' : 'light', isSys: 'sys');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<LocationShareProvider>(context).themeData,
      home: const SplashScreen(),
    );
  }
}
