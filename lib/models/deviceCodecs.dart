// To parse this JSON data, do
//
//     final codecs = codecsFromMap(jsonString);

import 'dart:convert';

DeviceCodecs codecsFromMap(String str) =>
    DeviceCodecs.fromMap(json.decode(str));

String codecsToMap(DeviceCodecs data) => json.encode(data.toMap());

class DeviceCodecs {
  DeviceCodecs({
    this.videoCodecs,
    this.audioCodecs,
  });

  List<Codec> videoCodecs;
  List<Codec> audioCodecs;

  factory DeviceCodecs.fromMap(Map<String, dynamic> json) => DeviceCodecs(
        videoCodecs: json['videoCodecs'] == null
            ? null
            : List<Codec>.from(
                json['videoCodecs'].map((x) => Codec.fromMap(x))),
        audioCodecs: json['audioCodecs'] == null
            ? null
            : List<Codec>.from(
                json['audioCodecs'].map((x) => Codec.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        if (videoCodecs != null)
          'videoCodecs': List<dynamic>.from(videoCodecs.map((x) => x.toMap())),
        if (audioCodecs != null)
          'audioCodecs': List<dynamic>.from(audioCodecs.map((x) => x.toMap())),
      };
}

class Codec {
  Codec({
    this.mimeType,
    this.codec,
    this.isAudio,
    this.profiles,
    this.levels,
    this.maxBitrate,
    this.maxChannels,
    this.maxSampleRate,
  });

  String mimeType;
  String codec;
  bool isAudio;
  List<String> profiles;
  List<int> levels;
  int maxBitrate;
  int maxChannels;
  int maxSampleRate;

  factory Codec.fromMap(Map<String, dynamic> json) => Codec(
        mimeType: json['mimeType'],
        codec: json['codec'],
        isAudio: json['isAudio'],
        profiles: json['profiles'] == null
            ? null
            : List<String>.from(json['profiles'].map((x) => x)),
        levels: json['levels'] == null
            ? null
            : List<int>.from(json['levels'].map((x) => x)),
        maxBitrate: json['maxBitrate'],
        maxChannels: json['maxChannels'],
        maxSampleRate: json['maxSampleRate'],
      );

  Map<String, dynamic> toMap() => {
        if (mimeType != null) 'mimeType': mimeType,
        if (codec != null) 'codec': codec,
        if (isAudio != null) 'isAudio': isAudio,
        if (profiles != null)
          'profiles': List<dynamic>.from(profiles.map((x) => x)),
        if (levels != null) 'levels': List<dynamic>.from(levels.map((x) => x)),
        if (maxBitrate != null) 'maxBitrate': maxBitrate,
        if (maxChannels != null) 'maxChannels': maxChannels,
        if (maxSampleRate != null) 'maxSampleRate': maxSampleRate,
      };
}
