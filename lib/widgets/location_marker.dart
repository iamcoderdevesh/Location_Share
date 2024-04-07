import 'package:flutter/material.dart';
import 'package:location_share/state/state.dart';
import 'package:provider/provider.dart';

class CustomMarker extends StatelessWidget {
  final String initial;
  final double? fontSize;
  final String? color;

  const CustomMarker({
    Key? key,
    required this.initial,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      late LocationShareProvider state =
      Provider.of<LocationShareProvider>(context, listen: false);
      late String colorChoice = color != null ? color.toString().substring(1) : state.color.substring(1);
    
    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse(colorChoice, radix: 16) + 0xFF000000),
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
