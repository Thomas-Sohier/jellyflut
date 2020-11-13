import 'package:device_info/device_info.dart';
import 'package:jellyflut/globals.dart';

Future<AndroidDeviceInfo> deviceInfo() async {
  var deviceInfo = DeviceInfoPlugin();
  var androidInfo = await deviceInfo.androidInfo;
  return androidInfo;
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
