import 'package:jellyflut/models/enumValues.dart';

enum Codec { H264, DTS, SUBRIP }

final codecValues =
    EnumValues({'dts': Codec.DTS, 'h264': Codec.H264, 'subrip': Codec.SUBRIP});

enum CodecTimeBase { THE_100148000, THE_148000, THE_01 }

final codecTimeBaseValues = EnumValues({
  '0/1': CodecTimeBase.THE_01,
  '1001/48000': CodecTimeBase.THE_100148000,
  '1/48000': CodecTimeBase.THE_148000
});

enum Language { ENG, FRE }

final languageValues = EnumValues({'eng': Language.ENG, 'fre': Language.FRE});

enum TimeBase { THE_11000 }

final timeBaseValues = EnumValues({'1/1000': TimeBase.THE_11000});

enum Type { VIDEO, AUDIO, SUBTITLE }

final typeValues = EnumValues(
    {'Audio': Type.AUDIO, 'Subtitle': Type.SUBTITLE, 'Video': Type.VIDEO});

class RequiredHttpHeaders {
  RequiredHttpHeaders();

  factory RequiredHttpHeaders.fromMap(Map<String, dynamic> json) =>
      RequiredHttpHeaders();

  Map<String, dynamic> toMap() => {};
}

enum PersonType { ACTOR, DIRECTOR, GUESTSTAR, WRITER, PRODUCER }

final personTypeValues = EnumValues({
  'Actor': PersonType.ACTOR,
  'Director': PersonType.DIRECTOR,
  'GuestStar': PersonType.GUESTSTAR,
  'Producer': PersonType.PRODUCER,
  'Writer': PersonType.WRITER
});
