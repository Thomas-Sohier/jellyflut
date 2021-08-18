library globals;

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/deviceProfile.dart';
import 'package:jellyflut/models/jellyfin/user.dart' as jellyfin_user;
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/database.dart';

final AppRouter _customRouter = AppRouter(authGuard: AuthGuard());
AppRouter get customRouter => _customRouter;

BuildContext get currentContext => customRouter.navigatorKey.currentContext!;

double get _itemHeightTemp =>
    log(MediaQuery.of(_customRouter.navigatorKey.currentContext!).size.width) *
    35;

double get itemHeight => (_itemHeightTemp <= 200 ? 200 : _itemHeightTemp);

// Used for some player to prevent from creating a new player
int get audioPlayerId => 132;
int get videoPlayerId => 213;

late SharedPreferences _sharedPrefs;

SharedPreferences get sharedPrefs => _sharedPrefs;

Future setUpSharedPrefs() async {
  _sharedPrefs = await SharedPreferences.getInstance();
  if (_sharedPrefs.getBool('isLoggedIn') ?? false) {
    await sharedPrefs.setBool('isLoggedIn', true);
  }
}

jellyfin_user.User? userJellyfin;
User? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = false;

final ScreenBreakpoints _screenBreakpoints =
    ScreenBreakpoints(tablet: 600, desktop: 720, watch: 300);

ScreenBreakpoints get screenBreakpoints => _screenBreakpoints;
