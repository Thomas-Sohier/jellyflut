import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<bool> isAuth() async {
  var isLogged = await isLoggedIn();
  if (isLogged) {
    await saveToGlobals();
    return true;
  }
  return false;
}

Future<bool> detectAndroidTv() async {
  if (Platform.isAndroid) {
    var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    var _isAndroidTv =
        androidDeviceInfo.systemFeatures.contains('android.software.leanback');
    return _isAndroidTv;
  }
  return false;
}

void showToast(String msg,
    {toastLength = Toast.LENGTH_SHORT, timeInSecForIosWeb = 1}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: Colors.grey[300],
      textColor: Colors.black,
      fontSize: 16.0);
}

double aspectRatio({String type}) {
  if (type == 'MusicAlbum') {
    return 1 / 1;
  }
  if (type == 'Backdrop') {
    return 16 / 9;
  }
  return 2 / 3;
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String removeAllHtmlTags(String htmlText) {
  var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

String getEnumValue(String enumValue) {
  return enumValue.substring(enumValue.toString().indexOf('.') + 1);
}
