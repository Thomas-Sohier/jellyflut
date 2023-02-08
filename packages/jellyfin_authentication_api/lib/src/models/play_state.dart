import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyfin_authentication_api/src/models/play_method.dart';
import 'package:jellyfin_authentication_api/src/models/repeat_mode.dart';

part 'play_state.freezed.dart';
part 'play_state.g.dart';

/// {@template playState}
/// A single playState item.
///
/// Contains a [canSeek], [isPaused], [isMuted] and a [repeatMode]
///
///
/// [PlayState]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class PlayState with _$PlayState {
  const factory PlayState(
      {int? positionTicks,
      required bool canSeek,
      required bool isPaused,
      required bool isMuted,
      int? volumeLevel,
      int? audiostreamindex,
      int? subtitlestreamindex,
      String? mediaSourceId,
      PlayMethod? playMethod,
      required RepeatMode repeatMode,
      String? liveStreamId}) = _PlayState;

  /// Deserializes the given [JsonMap] into a [Configuration].
  factory PlayState.fromJson(Map<String, Object?> json) => _$PlayStateFromJson(json);
}
