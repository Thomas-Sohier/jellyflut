// To parse this JSON data, do
//
//     final codecs = codecsFromMap(jsonString);

import 'dart:convert' hide Codec;

import 'codec.dart';

DeviceCodecs codecsFromMap(String str) => DeviceCodecs.fromMap(json.decode(str));

String codecsToMap(DeviceCodecs data) => json.encode(data.toMap());

class DeviceCodecs {
  DeviceCodecs({
    this.videoCodecs,
    this.audioCodecs,
  });

  List<Codec>? videoCodecs;
  List<Codec>? audioCodecs;

  factory DeviceCodecs.fromMap(Map<String, dynamic> json) => DeviceCodecs(
        videoCodecs:
            json['videoCodecs'] == null ? null : List<Codec>.from(json['videoCodecs'].map((x) => Codec.fromMap(x))),
        audioCodecs:
            json['audioCodecs'] == null ? null : List<Codec>.from(json['audioCodecs'].map((x) => Codec.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'videoCodecs': videoCodecs != null ? List<dynamic>.from(videoCodecs!.map((x) => x.toMap())) : null,
        'audioCodecs': audioCodecs != null ? List<dynamic>.from(audioCodecs!.map((x) => x.toMap())) : null,
      };
}
