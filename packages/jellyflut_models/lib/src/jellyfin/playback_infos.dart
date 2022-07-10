import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/index.dart';
import 'index.dart';

part 'playback_infos.freezed.dart';
part 'playback_infos.g.dart';

@Freezed()
class PlayBackInfos with _$PlayBackInfos {
  PlayBackInfos._();

  factory PlayBackInfos({required List<MediaSource> mediaSources, String? playSessionId, String? errorCode}) =
      _PlayBackInfos;

  factory PlayBackInfos.fromJson(Map<String, Object?> json) => _$PlayBackInfosFromJson(json);

  List<MediaStream> getSubtitles() {
    return mediaSources.first.mediaStreams.where((element) => element.type == MediaStreamType.Subtitle).toList();
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
