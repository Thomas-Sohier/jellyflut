import 'package:flutter/material.dart';

class SnackbarUtil {
  static void message(String message, IconData icon, Color color, {BuildContext? context}) {
    // context ??= context.router.root.navigatorKey.currentContext;

    // If cotnext is still null we show nothing
    if (context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Row(children: [Expanded(child: Text(message, maxLines: 3)), Icon(icon, color: color)]), width: 600));
  }
}
