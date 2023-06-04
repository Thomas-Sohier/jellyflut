import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';

Future<void> init() {
  if (!Platform.isMacOS) {
    DartVLC.initialize();
  }
  return Future.value(null);
}
