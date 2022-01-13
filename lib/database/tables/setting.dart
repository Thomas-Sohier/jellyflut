import 'dart:io';

import 'package:moor/moor.dart';

String getDefaultPlayer() {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return 'vlc';
  }
  return 'exoplayer';
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get preferredPlayer =>
      text().withDefault(Constant(getDefaultPlayer()))();
  TextColumn get preferredTranscodeAudioCodec =>
      text().withDefault(const Constant('auto'))();
  IntColumn get maxVideoBitrate =>
      integer().withDefault(const Constant(50000000))();
  IntColumn get maxAudioBitrate =>
      integer().withDefault(const Constant(8000000))();
  TextColumn get downloadPath => text().nullable()();
}
