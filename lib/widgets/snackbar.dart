import 'package:flutter/material.dart';

class ShowSnack {
  final String msg;
  final BuildContext context;
  ShowSnack(this.msg, this.context);

  SnackBar get snackBar {
    return SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
