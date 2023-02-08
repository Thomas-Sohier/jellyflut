import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, FToast fToast, {Duration? duration}) {
  final borderRadius = BorderRadius.all(Radius.circular(25));
  duration = duration ?? Duration(seconds: 1);
  //fToast.removeCustomToast();

  // Toast widget
  final toast = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.grey.shade200.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text(
              msg,
              style: TextStyle(color: Colors.black),
            ),
          )));

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
