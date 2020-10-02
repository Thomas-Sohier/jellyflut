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
  Random random = new Random();
  int id = random.nextInt(30);
  String version = "0.1";

  var auth =
      "MediaBrowser Client=\'${name}\', Device=\'${host}\', DeviceId=\'${id}\', Version=\'${version}\'";
  return auth;
}
