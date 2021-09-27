library globals;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/device_profile.dart';
import 'package:jellyflut/models/jellyfin/user.dart' as jellyfin_user;
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/database.dart';

final AppRouter _customRouter = AppRouter(authGuard: AuthGuard());
AppRouter get customRouter => _customRouter;

BuildContext get currentContext => customRouter.navigatorKey.currentContext!;

double get itemPosterHeight => 200;
double get itemPosterLabelHeight => 39;

// Used for some player to prevent from creating a new player
int get audioPlayerId => 132;
int get videoPlayerId => 213;

// Init sharedPref to know if is already logged
late SharedPreferences _sharedPrefs;

SharedPreferences get sharedPrefs => _sharedPrefs;

Future setUpSharedPrefs() async {
  _sharedPrefs = await SharedPreferences.getInstance();
  if (_sharedPrefs.getBool('isLoggedIn') ?? false) {
    await sharedPrefs.setBool('isLoggedIn', true);
  }
}

// Init android tv detection to know if platform is a TV

late bool _isAndroidTv;

bool get isAndroidTv => _isAndroidTv;

Future setUpAndroidTv() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    _isAndroidTv =
        androidInfo.systemFeatures.contains('android.software.leanback_only');
  } else {
    _isAndroidTv = false;
  }
}

// Specific stuff

jellyfin_user.User? userJellyfin;
User? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = true;
