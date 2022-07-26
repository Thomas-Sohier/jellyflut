library globals;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_io/io.dart';

const double itemPosterLabelHeight = 39;
const double itemPosterHeight = 200;

// Init android tv detection to know if platform is a TV
late final bool _isAndroidTv;
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
bool shimmerAnimation = true;
bool offlineMode = false;
