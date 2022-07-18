import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_type.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

@Freezed()
@immutable
class AudioTrack with _$AudioTrack {
  factory AudioTrack(
      {required int index,
      int? jellyfinSubtitleIndex,
      required MediaType mediaType,
      required String name}) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, Object?> json) => _$AudioTrackFromJson(json);
}
