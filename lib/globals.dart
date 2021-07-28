library globals;

import 'package:jellyflut/models/deviceProfile.dart';

import 'database/database.dart';
import 'models/user.dart' as user_jellyfin;

user_jellyfin.User userJellyfin;
User userApp;
Server server;
String apiKey;
DeviceProfile savedDeviceProfile;
bool isAndroidTv;
bool shimmerAnimation = false;
