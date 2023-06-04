import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_type.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

@immutable
@Freezed()
class AudioTrack with _$AudioTrack {
  const AudioTrack._();

  const factory AudioTrack(
      {required String index,
      int? jellyfinSubtitleIndex,
      required MediaType mediaType,
      required String name}) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, Object?> json) => _$AudioTrackFromJson(json);

  /// Empty audio track which represents an empty audio track.
  static const empty = AudioTrack(index: 'none', mediaType: MediaType.local, name: 'default');

  /// Convenience getter to determine whether the current audio track is empty.
  bool get isEmpty => this == AudioTrack.empty;

  /// Convenience getter to determine whether the current audio track is not empty.
  bool get isNotEmpty => this != AudioTrack.empty;
}
