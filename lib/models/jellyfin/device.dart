import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  String host;
  String model;
  String id;

  DeviceInfo({required this.host, required this.model, required this.id});

  static Future<DeviceInfo> getCurrentDeviceInfo() async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      var host = androidInfo.host;
      var id = androidInfo.id;
      var model = androidInfo.model;
      return DeviceInfo(host: host, model: model, id: id);
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      var host = iosInfo.localizedModel;
      var id = iosInfo.identifierForVendor;
      var model = iosInfo.model;
      return DeviceInfo(host: host, model: model, id: id);
    } else {
      return DeviceInfo(host: 'Unknown', model: 'Unknown', id: 'Unkonwn');
    }
  }
}
