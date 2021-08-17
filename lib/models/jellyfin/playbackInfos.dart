import 'dart:convert';

import 'package:jellyflut/models/enum/mediaStreamType.dart';
import 'package:jellyflut/models/jellyfin/mediaStream.dart';

import 'mediaSource.dart';

PlayBackInfos playBackInfosFromMap(String str) =>
    PlayBackInfos.fromMap(json.decode(str));

String playBackInfosToMap(PlayBackInfos data) => json.encode(data.toMap());

class PlayBackInfos {
  PlayBackInfos({
    required this.mediaSources,
    required this.playSessionId,
  });

  List<MediaSource> mediaSources;
  String playSessionId;

  factory PlayBackInfos.fromMap(Map<String, dynamic> json) => PlayBackInfos(
        mediaSources: List<MediaSource>.from(
            json['MediaSources'].map((x) => MediaSource.fromMap(x))),
        playSessionId: json['PlaySessionId'],
      );

  Map<String, dynamic> toMap() => {
        'MediaSources': List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        'PlaySessionId': playSessionId,
      };

  List<MediaStream> getSubtitles() {
    return mediaSources.first.mediaStreams != null
        ? mediaSources.first.mediaStreams!
            .where((element) => element.type == MediaStreamType.SUBTITLE)
            .toList()
        : [];
  }

  bool isTranscoding() {
    if (mediaSources.first.transcodingUrl != null) return true;
    return false;
  }
}
