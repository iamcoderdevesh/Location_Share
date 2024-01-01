import 'package:flutter/material.dart';
import 'package:location_share/themes/theme.dart';
import 'package:location_share/widgets/bottomNavbar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const BottoNavBar(),
    );
  }
}
