import 'dart:convert';

import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/jellyfin/media_stream.dart';

import 'media_source.dart';

PlayBackInfos playBackInfosFromMap(String str) =>
    PlayBackInfos.fromMap(json.decode(str));

String playBackInfosToMap(PlayBackInfos data) => json.encode(data.toMap());

class PlayBackInfos {
  PlayBackInfos({
    required this.mediaSources,
    this.playSessionId,
    this.errorCode,
  });

  List<MediaSource> mediaSources;
  String? playSessionId;
  String? errorCode;

  factory PlayBackInfos.fromMap(Map<String, dynamic> json) => PlayBackInfos(
        mediaSources: List<MediaSource>.from(
            json['MediaSources'].map((x) => MediaSource.fromMap(x))),
        playSessionId: json['PlaySessionId'],
        errorCode: json['ErrorCode'],
      );

  Map<String, dynamic> toMap() => {
        'MediaSources': List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        'PlaySessionId': playSessionId,
        'ErrorCode': errorCode,
      };

  List<MediaStream> getSubtitles() {
    return mediaSources.first.mediaStreams != null
        ? mediaSources.first.mediaStreams!
            .where((element) => element.type == MediaStreamType.SUBTITLE)
            .toList()
        : [];
  }

  bool hasError() {
    return errorCode != null && errorCode!.isNotEmpty;
  }

  String getErrorMessage() {
    switch (errorCode) {
      case 'NoCompatibleStream':
        return 'No compatible stream returned';
      case 'NotAllowed':
        return 'You\'re not allowed to watch this stream';
      case 'RateLimitExceeded':
        return 'Too many request';
      default:
        return errorCode!;
    }
  }

  bool isTranscoding() {
    if (mediaSources.isNotEmpty && mediaSources.first.transcodingUrl != null) {
      return true;
    }
    return false;
  }
}
