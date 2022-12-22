import 'package:dart_vlc/dart_vlc.dart';

Future<void> init() {
  DartVLC.initialize();
  return Future.value(null);
}
