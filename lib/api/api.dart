import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:jellyflut/globals.dart';

class DeviceInfo {
  String host;
  String model;
  String id;
}

Future<DeviceInfo> deviceInfo() async {
  var deviceInfoPlugin = DeviceInfoPlugin();
  var deviceInfo = DeviceInfo();
  if (Platform.isAndroid) {
    var androidInfo = await deviceInfoPlugin.androidInfo;
    deviceInfo.host = androidInfo.host;
    deviceInfo.id = androidInfo.id;
    deviceInfo.model = androidInfo.model;
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfoPlugin.iosInfo;
    deviceInfo.host = iosInfo.localizedModel;
    deviceInfo.id = iosInfo.identifierForVendor;
    deviceInfo.model = iosInfo.model;
  }
  return deviceInfo;
}

Future<String> authHeader() async {
  // device infos
  var device = await deviceInfo();

  // data
  var name = 'jellyflut';
  var host = device.host;
  var id = device.id;
  var version = '0.0.1';
  var token = apiKey;

  var auth =
      'MediaBrowser Client=\"${name}\", Device=\"${host}\", DeviceId=\"${id}\", Version=\"${version}\", Token="${token}"';
  return auth;
}
