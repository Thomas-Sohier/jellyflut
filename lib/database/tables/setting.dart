import 'package:moor/moor.dart';

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get preferredPlayer =>
      text().withDefault(const Constant('exoplayer'))();
  TextColumn get preferredTranscodeAudioCodec =>
      text().withDefault(const Constant('auto'))();
  IntColumn get maxVideoBitrate =>
      integer().withDefault(const Constant(140000000))();
  IntColumn get maxAudioBitrate =>
      integer().withDefault(const Constant(320000))();
}
