import 'dart:developer';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  String host;
  String model;
  String id;

  DeviceInfo({required this.host, required this.model, required this.id});

  static Future<DeviceInfo> getCurrentDeviceInfo() async {
    return loadCurrentDeviceInfo().catchError((error, stacktrace) {
      log('Cannot load device info', level: Level.WARNING.value, error: error);
      return Future.value(DeviceInfo(host: 'Unknown', id: 'Unknown', model: 'Unknown'));
    });
  }

  static Future<DeviceInfo> loadCurrentDeviceInfo() async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final host = androidInfo.host;
      final id = androidInfo.id;
      final model = androidInfo.model;
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
    } else if (kIsWeb) {
      final webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      final host = webBrowserInfo.appName ?? 'Unknown';
      final id = 'Unknown';
      final model = webBrowserInfo.platform ?? 'Unknown';
      return DeviceInfo(host: host, model: model, id: id);
    } else {
      return DeviceInfo(host: 'Unknown', model: 'Unknown', id: 'Unkonwn');
    }
  }
}
