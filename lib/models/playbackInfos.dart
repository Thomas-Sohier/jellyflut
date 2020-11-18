import 'dart:convert';

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
        playSessionId:
            json['PlaySessionId'] == null ? null : json['PlaySessionId'],
      );

  Map<String, dynamic> toMap() => {
        'MediaSources': mediaSources == null
            ? null
            : List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        'PlaySessionId': playSessionId == null ? null : playSessionId,
      };
}
