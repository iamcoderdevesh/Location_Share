import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade500,
    primary: Colors.grey.shade200,
    onSurface: Colors.grey.shade400,
    secondary: Colors.white,
    onInverseSurface: Colors.black,
    inversePrimary: Colors.grey.shade700,
  )
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    onSurface: Colors.grey.shade300,
    secondary: Colors.black,
    onInverseSurface: Colors.white,
    inversePrimary: Colors.grey.shade700,
  )
);