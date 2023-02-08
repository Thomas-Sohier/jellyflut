import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  // Override behavior methods and getters like dragDevices
  // Used to fix issue : https://github.com/flutter/flutter/issues/83359
  // So we can drag horizontally again on desktop
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
