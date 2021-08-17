library globals;

import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/deviceProfile.dart';
import 'package:jellyflut/models/jellyfin/user.dart' as jellyfin_user;
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'database/database.dart';

final AppRouter _customRouter = AppRouter(authGuard: AuthGuard());
AppRouter get customRouter => _customRouter;

BuildContext get currentContext => customRouter.navigatorKey.currentContext!;

double get _itemHeightTemp =>
    (MediaQuery.of(_customRouter.navigatorKey.currentContext!).size.height / 3);
double get itemHeight => (_itemHeightTemp <= 200 ? 200 : _itemHeightTemp);
jellyfin_user.User? userJellyfin;
User? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = false;
final screenBreakpoints =
    ScreenBreakpoints(tablet: 600, desktop: 720, watch: 300);
