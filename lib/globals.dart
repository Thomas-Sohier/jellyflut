library globals;

import 'package:jellyflut/models/deviceProfile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'database/database.dart';
import 'models/user.dart' as user_jellyfin;

user_jellyfin.User? userJellyfin;
User? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = false;
final screenBreakpoints =
    ScreenBreakpoints(tablet: 600, desktop: 720, watch: 300);
