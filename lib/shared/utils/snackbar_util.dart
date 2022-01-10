import 'package:flutter/material.dart';

class SnackbarUtil {
  static void message(
      BuildContext? context, String message, IconData icon, Color color) {
    if (context == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Row(children: [
            Flexible(child: Text(message, maxLines: 3)),
            Icon(icon, color: color)
          ]),
          width: 600));
  }
}
