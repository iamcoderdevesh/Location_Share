import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String initial;
  final Color? color;

  const CustomMarker({
    Key? key,
    required this.initial,
    this.color,
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
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
