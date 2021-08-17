import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/device.dart';

Future<String> authHeader() async {
  // device infos
  var device = await DeviceInfo.getCurrentDeviceInfo();

  // data
  var name = 'jellyflut';
  var host = device.host;
  var id = device.id;
  var version = '0.0.1';
  var token = apiKey;

  var auth =
      'MediaBrowser Client=\"$name\", Device=\"$host\", DeviceId=\"$id\", Version=\"$version\"';
  if (apiKey != null) auth = auth + ', Token="$token"';
  return auth;
}
