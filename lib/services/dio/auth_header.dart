import 'dart:developer';
import 'package:logging/logging.dart';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/device.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> authHeader({bool embedToken = true}) async {
  // device infos
  final device = await DeviceInfo.getCurrentDeviceInfo();

  // data
  final name = 'jellyflut';
  final host = device.host;
  final id = device.id;
  final version = await _getBuildNumber();
  final token = apiKey;

  var auth =
      'MediaBrowser Client="$name", Device="$host", DeviceId="$id", Version="$version"';
  if (embedToken && apiKey != null) auth = '$auth, Token="$token"';
  return auth;
}

Future<String> _getBuildNumber() async {
  try {
    final packageInfos = await PackageInfo.fromPlatform();
    return packageInfos.buildNumber.isEmpty
        ? 'Unknown'
        : packageInfos.buildNumber;
  } catch (error) {
    log(error.toString(), level: Level.WARNING.value);
    return 'Unkown';
  }
}
