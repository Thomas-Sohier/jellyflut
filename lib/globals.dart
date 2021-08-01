library globals;

import 'package:jellyflut/models/deviceProfile.dart';

import 'database/database.dart';
import 'models/user.dart' as user_jellyfin;

user_jellyfin.User? userJellyfin;
User? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = false;
