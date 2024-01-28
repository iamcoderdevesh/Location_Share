import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String initial;
  final Color? color;
  final double? fontSize;

  const CustomMarker({
    Key? key,
    required this.initial,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
              fontSize: fontSize ?? 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
