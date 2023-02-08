import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyfin_authentication_api/src/models/supported_command.dart';

import 'play_state.dart';

part 'session_infos.freezed.dart';
part 'session_infos.g.dart';

/// {@template sessionInfo}
/// A single sessionInfo item.
///
/// Contains a [playState], [additionalUsers], [capabilities], [remoteEndPoint],
/// [playableMediaTypes], [id], [userId], [userName], [client],
/// [lastActivityDate], [lastPlaybackCheckIn], [deviceName], [deviceId],
/// [applicationVersion], [isActive], [supportsMediaControl],
/// [supportsRemoteControl], [hasCustomDeviceName], [serverId],
/// [userPrimaryImageTag] and [supportedCommands],
///
///
/// [SessionInfo]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class SessionInfo with _$SessionInfo {
  const factory SessionInfo(
      {PlayState? playState,
      @Default([]) List<dynamic> additionalUsers,

      /// Capabilities capabilities, // TODO later if needed
      String? remoteEndPoint,
      @Default(<String>[]) List<String> playableMediaTypes,
      String? id,
      required String userId,
      String? userName,
      String? client,
      required DateTime lastActivityDate,
      required DateTime lastPlaybackCheckIn,
      String? deviceId,
      String? deviceName,
      String? deviceType,
      // Item? nowPlayingItem         // TODO later if needed
      // dynamic fullNowPlayingItem   // TODO later if needed
      // Item? nowViewingItem         // TODO later if needed
      // dynamic transcodingInfo      // TODO later if needed
      String? applicationVersion,
      required bool isActive,
      required bool supportsMediaControl,
      required bool supportsRemoteControl,
      required bool hasCustomDeviceName,
      String? serverId,
      String? userPrimaryImageTag,
      @Default(<SupportedCommands>[]) List<SupportedCommands> supportedCommands}) = _SessionInfo;

  /// Deserializes the given [JsonMap] into a [SessionInfo].
  factory SessionInfo.fromJson(Map<String, Object?> json) => _$SessionInfoFromJson(json);
}
