import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, FToast fToast, {Duration? duration}) {
  duration = duration ?? Duration(seconds: 1);
  fToast.removeCustomToast();

  // Toast widget
  Widget toast = Container(
    color: Colors.grey[300],
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    child: Text(msg),
  );

  fToast.showToast(
    child: toast,
    toastDuration: duration,
    gravity: ToastGravity.BOTTOM,
  );
}

void removeToast(FToast fToast) {
  fToast.removeCustomToast();
}

void removeAllQueuedToasts(FToast fToast) {
  fToast.removeQueuedCustomToasts();
}
