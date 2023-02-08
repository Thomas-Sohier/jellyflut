import 'package:package_info_plus/package_info_plus.dart';

import '../models/device.dart';

abstract class TokenHelper {
  static Future<String> generateHeader({String? accessToken, bool embedToken = true}) async {
    // device infos
    final device = await DeviceInfo.getCurrentDeviceInfo();

    // data
    final name = 'jellyflut';
    final host = device.host;
    final id = device.id;
    final version = await _getBuildNumber();
    final token = accessToken;

    var auth = 'MediaBrowser Client="$name", Device="$host", DeviceId="$id", Version="$version"';
    if (embedToken && accessToken != null) auth = '$auth, Token="$token"';
    return auth;
  }

  static Future<String> _getBuildNumber() async {
    try {
      final packageInfos = await PackageInfo.fromPlatform();
      return packageInfos.buildNumber.isEmpty ? 'Unknown' : packageInfos.buildNumber;
    } catch (error) {
      return 'Unkown';
    }
  }
}
