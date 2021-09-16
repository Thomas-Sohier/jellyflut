import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/device.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> authHeader() async {
  // device infos
  final device = await DeviceInfo.getCurrentDeviceInfo();
  final packageInfos = await PackageInfo.fromPlatform();

  // data
  final name = 'jellyflut';
  final host = device.host;
  final id = device.id;
  final version =
      packageInfos.buildNumber.isEmpty ? 'Unknown' : packageInfos.buildNumber;
  final token = apiKey;

  var auth =
      'MediaBrowser Client=\"$name\", Device=\"$host\", DeviceId=\"$id\", Version=\"$version\"';
  if (apiKey != null) auth = auth + ', Token="$token"';
  return auth;
}
