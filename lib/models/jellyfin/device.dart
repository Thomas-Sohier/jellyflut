import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  String host;
  String model;
  String id;

  DeviceInfo({required this.host, required this.model, required this.id});

  static Future<DeviceInfo> getCurrentDeviceInfo() async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final host = androidInfo.host ?? 'Unknown';
      final id = androidInfo.id ?? 'Unknown';
      final model = androidInfo.model ?? 'Unknown';
      return DeviceInfo(host: host, model: model, id: id);
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      final host = iosInfo.localizedModel ?? 'Unknown';
      final id = iosInfo.identifierForVendor ?? 'Unknown';
      final model = iosInfo.model ?? 'Unknown';
      return DeviceInfo(host: host, model: model, id: id);
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfoPlugin.linuxInfo;
      final host = linuxInfo.name;
      final id = linuxInfo.id;
      final model = linuxInfo.variant ?? 'Unknown';
      return DeviceInfo(host: host, model: model, id: id);
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfoPlugin.windowsInfo;
      final host = windowsInfo.computerName;
      final id = 'Unknown';
      final model = 'Unknown';
      return DeviceInfo(host: host, model: model, id: id);
    } else if (Platform.isMacOS) {
      final macOsInfo = await deviceInfoPlugin.macOsInfo;
      final host = macOsInfo.hostName;
      final id = 'Unknown';
      final model = macOsInfo.model;
      return DeviceInfo(host: host, model: model, id: id);
    } else {
      return DeviceInfo(host: 'Unknown', model: 'Unknown', id: 'Unkonwn');
    }
  }
}
