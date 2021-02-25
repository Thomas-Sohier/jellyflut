library globals;

import 'package:jellyflut/models/deviceProfile.dart';
import 'package:jellyflut/models/server.dart';
import 'package:jellyflut/models/userDB.dart';

import 'models/user.dart';

User user;
bool isAndroidTv;

/// Server to request
/// ${class Server}
Server server;
UserDB userDB;
String apiKey;
DeviceProfile savedDeviceProfile;
