import 'dart:convert';

import 'package:jellyflut/models/mediaStream.dart';

import 'mediaSource.dart';

PlayBackInfos playBackInfosFromMap(String str) =>
    PlayBackInfos.fromMap(json.decode(str));

String playBackInfosToMap(PlayBackInfos data) => json.encode(data.toMap());

class PlayBackInfos {
  PlayBackInfos({
    this.mediaSources,
    this.playSessionId,
  });

  List<MediaSource> mediaSources;
  String playSessionId;

  factory PlayBackInfos.fromMap(Map<String, dynamic> json) => PlayBackInfos(
        mediaSources: json['MediaSources'] == null
            ? null
            : List<MediaSource>.from(
                json['MediaSources'].map((x) => MediaSource.fromMap(x))),
        playSessionId: json['PlaySessionId'],
      );

  Map<String, dynamic> toMap() => {
        'MediaSources': mediaSources == null
            ? null
            : List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        'PlaySessionId': playSessionId,
      };

  List<MediaStream> getSubtitles() {
    return mediaSources.first.mediaStreams != null
        ? mediaSources.first.mediaStreams
            .where((element) => element.type.trim().toLowerCase() == 'subtitle')
            .toList()
        : [];
  }

  bool isTranscoding() {
    if (mediaSources?.first?.transcodingUrl != null) return true;
    return false;
  }
}
