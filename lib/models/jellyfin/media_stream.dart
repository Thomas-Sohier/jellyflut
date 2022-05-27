import 'package:jellyflut/models/enum/codec.dart';
import 'package:jellyflut/models/enum/codec_time_base.dart';
import 'package:jellyflut/models/enum/language.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/enum/time_base.dart';

class MediaStream {
  MediaStream({
    this.codec,
    this.language,
    this.colorTransfer,
    this.colorPrimaries,
    this.timeBase,
    this.codecTimeBase,
    this.videoRange,
    this.displayTitle,
    this.nalLengthSize,
    this.isInterlaced,
    this.isAvc,
    this.bitRate,
    this.bitDepth,
    this.refFrames,
    this.isDefault,
    this.isForced,
    this.height,
    this.width,
    this.averageFrameRate,
    this.realFrameRate,
    this.profile,
    required this.type,
    this.aspectRatio,
    required this.index,
    this.isExternal,
    this.deliveryMethod,
    this.deliveryUrl,
    this.isTextSubtitleStream,
    this.supportsExternalStream,
    this.pixelFormat,
    this.level,
    this.channelLayout,
    this.channels,
    this.sampleRate,
    this.title,
    this.localizedUndefined,
    this.localizedDefault,
    this.localizedForced,
  });

  String? codec;
  Language? language;
  String? colorTransfer;
  String? colorPrimaries;
  String? timeBase;
  String? codecTimeBase;
  String? videoRange;
  String? displayTitle;
  String? nalLengthSize;
  bool? isInterlaced;
  bool? isAvc;
  int? bitRate;
  int? bitDepth;
  int? refFrames;
  bool? isDefault;
  bool? isForced;
  int? height;
  int? width;
  double? averageFrameRate;
  double? realFrameRate;
  String? profile;
  MediaStreamType type;
  String? aspectRatio;
  int index;
  bool? isExternal;
  String? deliveryMethod;
  String? deliveryUrl;
  bool? isTextSubtitleStream;
  bool? supportsExternalStream;
  String? pixelFormat;
  int? level;
  String? channelLayout;
  int? channels;
  int? sampleRate;
  String? title;
  String? localizedUndefined;
  String? localizedDefault;
  String? localizedForced;

  factory MediaStream.fromMap(Map<String, dynamic> json) => MediaStream(
        codec: json['Codec'],
        language: languageValues.map[json['Language']],
        colorTransfer: json['ColorTransfer'],
        colorPrimaries: json['ColorPrimaries'],
        timeBase: json['TimeBase'],
        codecTimeBase: json['CodecTimeBase'],
        videoRange: json['VideoRange'],
        displayTitle: json['DisplayTitle'],
        nalLengthSize: json['NalLengthSize'],
        isInterlaced: json['IsInterlaced'],
        isAvc: json['IsAVC'],
        bitRate: json['BitRate'],
        bitDepth: json['BitDepth'],
        refFrames: json['RefFrames'],
        isDefault: json['IsDefault'],
        isForced: json['IsForced'],
        height: json['Height'],
        width: json['Width'],
        averageFrameRate: json['AverageFrameRate'] == null
            ? null
            : json['AverageFrameRate'].toDouble(),
        realFrameRate: json['RealFrameRate'] == null
            ? null
            : json['RealFrameRate'].toDouble(),
        profile: json['Profile'],
        type: MediaStreamType.fromString(json['Type']),
        aspectRatio: json['AspectRatio'],
        index: json['Index'],
        isExternal: json['IsExternal'],
        deliveryMethod: json['DeliveryMethod'],
        deliveryUrl: json['DeliveryUrl'],
        isTextSubtitleStream: json['IsTextSubtitleStream'],
        supportsExternalStream: json['SupportsExternalStream'],
        pixelFormat: json['PixelFormat'],
        level: json['Level'],
        channelLayout: json['ChannelLayout'],
        channels: json['Channels'],
        sampleRate: json['SampleRate'],
        title: json['Title'],
        localizedUndefined: json['localizedUndefined'],
        localizedDefault: json['localizedDefault'],
        localizedForced: json['localizedForced'],
      );

  Map<String, dynamic> toMap() => {
        'Codec': codecValues.reverse[codec],
        'Language': languageValues.reverse[language],
        'ColorTransfer': colorTransfer,
        'ColorPrimaries': colorPrimaries,
        'TimeBase': timeBaseValues.reverse[timeBase],
        'CodecTimeBase': codecTimeBaseValues.reverse[codecTimeBase],
        'VideoRange': videoRange,
        'DisplayTitle': displayTitle,
        'NalLengthSize': nalLengthSize,
        'IsInterlaced': isInterlaced,
        'IsAVC': isAvc,
        'BitRate': bitRate,
        'BitDepth': bitDepth,
        'RefFrames': refFrames,
        'IsDefault': isDefault,
        'IsForced': isForced,
        'Height': height,
        'Width': width,
        'AverageFrameRate': averageFrameRate,
        'RealFrameRate': realFrameRate,
        'Profile': profile,
        'Type': type.value,
        'AspectRatio': aspectRatio,
        'Index': index,
        'IsExternal': isExternal,
        'DeliveryMethod': deliveryMethod,
        'DeliveryUrl': deliveryUrl,
        'IsTextSubtitleStream': isTextSubtitleStream,
        'SupportsExternalStream': supportsExternalStream,
        'PixelFormat': pixelFormat,
        'Level': level,
        'ChannelLayout': channelLayout,
        'Channels': channels,
        'SampleRate': sampleRate,
        'Title': title,
        'localizedUndefined': localizedUndefined,
        'localizedDefault': localizedDefault,
        'localizedForced': localizedForced,
      };

  bool isRemote() {
    if (isExternal != null) return isExternal!;
    return true;
  }
}
