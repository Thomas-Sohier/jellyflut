library globals;

import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:universal_io/io.dart';

final AppRouter _customRouter = AppRouter();
AppRouter get customRouter => _customRouter;

BuildContext get currentContext => customRouter.navigatorKey.currentContext!;

double get _itemHeightTemp => log(MediaQuery.of(_customRouter.navigatorKey.currentContext!).size.width) * 30;

double get itemPosterHeight => (_itemHeightTemp <= 150 ? 150 : _itemHeightTemp);

double get itemPosterLabelHeight => 39;

// Used for some player to prevent from creating a new player
int get audioPlayerId => 132;
int get videoPlayerId => 213;

// Init android tv detection to know if platform is a TV

late bool _isAndroidTv;

bool get isAndroidTv => _isAndroidTv;

Future setUpAndroidTv() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    _isAndroidTv = androidInfo.systemFeatures.contains('android.software.leanback_only');
  } else {
    _isAndroidTv = false;
  }
}

// Theming

const BorderRadius borderRadiusButton = BorderRadius.all(Radius.circular(16));

// Specific stuff
// TODO rework this as a provider later
User? userJellyfin;
UserAppData? userApp;
Server server = Server(id: 0, url: 'http://localhost', name: 'localhost');
String? apiKey;
DeviceProfile? savedDeviceProfile;
bool shimmerAnimation = true;
bool offlineMode = false;
