import 'package:flutter/material.dart';

Future<dynamic> bottomSheetModal(BuildContext context, Widget child) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) {
      return child;
    },
  );
}

class Popover extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets? margin;

  const Popover({
    Key? key,
    required this.child,
    this.height,
    this.margin,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHandle(context),
          child
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.1,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}