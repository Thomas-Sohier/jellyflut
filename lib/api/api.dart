import 'dart:math';
import 'package:device_info/device_info.dart';

deviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo;
}

Future<String> authHeader() async {
  // device infos
  AndroidDeviceInfo device = await deviceInfo();

  // data
  String name = "jellyflut";
  String host = device.host;
  String id = device.id;
  String version = "10.6.4";

  var auth =
      'MediaBrowser Client=\"${name}\", Device=\"${host}\", DeviceId=\"${id}\", Version=\"${version}\"';
  return auth;
}
