import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:universal_io/io.dart';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

String getDefaultPlayer() {
  if (kIsWeb) {
    return StreamingSoftware.HTMLPlayer.name;
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return StreamingSoftware.VLC.name;
  }
  return StreamingSoftware.EXOPLAYER.name;
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get preferredPlayer => text().withDefault(Constant(getDefaultPlayer()))();
  TextColumn get preferredTranscodeAudioCodec => text().withDefault(const Constant('auto'))();
  IntColumn get maxVideoBitrate => integer().withDefault(const Constant(50000000))();
  IntColumn get maxAudioBitrate => integer().withDefault(const Constant(8000000))();
  TextColumn get downloadPath => text().withDefault(const Constant(''))();
  BoolColumn get directPlay => boolean().withDefault(const Constant(false))();
}
