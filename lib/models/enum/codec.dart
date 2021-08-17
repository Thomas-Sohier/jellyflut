import 'enumValues.dart';

enum Codec { H264, DTS, SUBRIP }

final codecValues =
    EnumValues({'dts': Codec.DTS, 'h264': Codec.H264, 'subrip': Codec.SUBRIP});
