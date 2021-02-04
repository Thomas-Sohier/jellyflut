import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  String host;
  String model;
  String id;

  DeviceInfo({this.host, this.model, this.id});

  Future<DeviceInfo> getCurrentDeviceInfo() async {
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
}