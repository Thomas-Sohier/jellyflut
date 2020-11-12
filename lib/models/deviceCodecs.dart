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
        mimeType: json['mimeType'] ?? null,
        codec: json['codec'] ?? null,
        isAudio: json['isAudio'] ?? null,
        profiles: json['profiles'] == null
            ? null
            : List<String>.from(json['profiles'].map((x) => x)),
        levels: json['levels'] == null
            ? null
            : List<int>.from(json['levels'].map((x) => x)),
        maxBitrate: json['maxBitrate'] ?? null,
        maxChannels: json['maxChannels'] ?? null,
        maxSampleRate: json['maxSampleRate'] ?? null,
      );

  Map<String, dynamic> toMap() => {
        if (mimeType != null) 'mimeType': mimeType ?? null,
        if (codec != null) 'codec': codec ?? null,
        if (isAudio != null) 'isAudio': isAudio ?? null,
        if (profiles != null)
          'profiles': List<dynamic>.from(profiles.map((x) => x)),
        if (levels != null) 'levels': List<dynamic>.from(levels.map((x) => x)),
        if (maxBitrate != null) 'maxBitrate': maxBitrate ?? null,
        if (maxChannels != null) 'maxChannels': maxChannels ?? null,
        if (maxSampleRate != null) 'maxSampleRate': maxSampleRate ?? null,
      };
}
