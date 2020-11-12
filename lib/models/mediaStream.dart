import 'package:jellyflut/shared/enums.dart';

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
    this.type,
    this.aspectRatio,
    this.index,
    this.isExternal,
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

  String codec;
  Language language;
  String colorTransfer;
  String colorPrimaries;
  String timeBase;
  String codecTimeBase;
  String videoRange;
  String displayTitle;
  String nalLengthSize;
  bool isInterlaced;
  bool isAvc;
  int bitRate;
  int bitDepth;
  int refFrames;
  bool isDefault;
  bool isForced;
  int height;
  int width;
  double averageFrameRate;
  double realFrameRate;
  String profile;
  String type;
  String aspectRatio;
  int index;
  bool isExternal;
  bool isTextSubtitleStream;
  bool supportsExternalStream;
  String pixelFormat;
  int level;
  String channelLayout;
  int channels;
  int sampleRate;
  String title;
  String localizedUndefined;
  String localizedDefault;
  String localizedForced;

  factory MediaStream.fromMap(Map<String, dynamic> json) => MediaStream(
        codec: json["Codec"],
        language: languageValues.map[json["Language"]],
        colorTransfer:
            json["ColorTransfer"] == null ? null : json["ColorTransfer"],
        colorPrimaries:
            json["ColorPrimaries"] == null ? null : json["ColorPrimaries"],
        timeBase: json["TimeBase"],
        codecTimeBase: json["CodecTimeBase"],
        videoRange: json["VideoRange"] == null ? null : json["VideoRange"],
        displayTitle: json["DisplayTitle"],
        nalLengthSize:
            json["NalLengthSize"] == null ? null : json["NalLengthSize"],
        isInterlaced: json["IsInterlaced"],
        isAvc: json["IsAVC"] == null ? null : json["IsAVC"],
        bitRate: json["BitRate"] == null ? null : json["BitRate"],
        bitDepth: json["BitDepth"] == null ? null : json["BitDepth"],
        refFrames: json["RefFrames"] == null ? null : json["RefFrames"],
        isDefault: json["IsDefault"],
        isForced: json["IsForced"],
        height: json["Height"] == null ? null : json["Height"],
        width: json["Width"] == null ? null : json["Width"],
        averageFrameRate: json["AverageFrameRate"] == null
            ? null
            : json["AverageFrameRate"].toDouble(),
        realFrameRate: json["RealFrameRate"] == null
            ? null
            : json["RealFrameRate"].toDouble(),
        profile: json["Profile"] == null ? null : json["Profile"],
        type: json["Type"],
        aspectRatio: json["AspectRatio"] == null ? null : json["AspectRatio"],
        index: json["Index"],
        isExternal: json["IsExternal"],
        isTextSubtitleStream: json["IsTextSubtitleStream"],
        supportsExternalStream: json["SupportsExternalStream"],
        pixelFormat: json["PixelFormat"] == null ? null : json["PixelFormat"],
        level: json["Level"],
        channelLayout:
            json["ChannelLayout"] == null ? null : json["ChannelLayout"],
        channels: json["Channels"] == null ? null : json["Channels"],
        sampleRate: json["SampleRate"] == null ? null : json["SampleRate"],
        title: json["Title"] == null ? null : json["Title"],
        localizedUndefined: json["localizedUndefined"] == null
            ? null
            : json["localizedUndefined"],
        localizedDefault:
            json["localizedDefault"] == null ? null : json["localizedDefault"],
        localizedForced:
            json["localizedForced"] == null ? null : json["localizedForced"],
      );

  Map<String, dynamic> toMap() => {
        "Codec": codecValues.reverse[codec],
        "Language": languageValues.reverse[language],
        "ColorTransfer": colorTransfer == null ? null : colorTransfer,
        "ColorPrimaries": colorPrimaries == null ? null : colorPrimaries,
        "TimeBase": timeBaseValues.reverse[timeBase],
        "CodecTimeBase": codecTimeBaseValues.reverse[codecTimeBase],
        "VideoRange": videoRange == null ? null : videoRange,
        "DisplayTitle": displayTitle,
        "NalLengthSize": nalLengthSize == null ? null : nalLengthSize,
        "IsInterlaced": isInterlaced,
        "IsAVC": isAvc == null ? null : isAvc,
        "BitRate": bitRate == null ? null : bitRate,
        "BitDepth": bitDepth == null ? null : bitDepth,
        "RefFrames": refFrames == null ? null : refFrames,
        "IsDefault": isDefault,
        "IsForced": isForced,
        "Height": height == null ? null : height,
        "Width": width == null ? null : width,
        "AverageFrameRate": averageFrameRate == null ? null : averageFrameRate,
        "RealFrameRate": realFrameRate == null ? null : realFrameRate,
        "Profile": profile == null ? null : profile,
        "Type": typeValues.reverse[type],
        "AspectRatio": aspectRatio == null ? null : aspectRatio,
        "Index": index,
        "IsExternal": isExternal,
        "IsTextSubtitleStream": isTextSubtitleStream,
        "SupportsExternalStream": supportsExternalStream,
        "PixelFormat": pixelFormat == null ? null : pixelFormat,
        "Level": level,
        "ChannelLayout": channelLayout == null ? null : channelLayout,
        "Channels": channels == null ? null : channels,
        "SampleRate": sampleRate == null ? null : sampleRate,
        "Title": title == null ? null : title,
        "localizedUndefined":
            localizedUndefined == null ? null : localizedUndefined,
        "localizedDefault": localizedDefault == null ? null : localizedDefault,
        "localizedForced": localizedForced == null ? null : localizedForced,
      };
}
