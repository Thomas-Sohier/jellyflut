import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyfin_authentication_api/src/models/sync_play_access.dart';

part 'policy.freezed.dart';
part 'policy.g.dart';

/// {@template configuration}
/// A single configuration item.
///
/// Contains a
/// [isAdministrator], [isHidden], [isDisabled], [blockedTags], [enableUserPreferenceAccess],
/// [accessSchedules], [blockUnratedItems], [enableRemoteControlOfOtherUsers],
/// [enableSharedDeviceControl], [enableRemoteAccess], [enableLiveTvManagement],
/// [enableLiveTvAccess], [enableMediaPlayback], [enableAudioPlaybackTranscoding],
/// [enableVideoPlaybackTranscoding], [enablePlaybackRemuxing],
/// [forceRemoteSourceTranscoding], [enableContentDeletion],
/// [enableContentDeletionFromFolders], [enableContentDownloading],
/// [enableSyncTranscoding], [enableMediaConversion], [enabledDevices],
/// [enableAllDevices], [enabledChannels], [enableAllChannels],
/// [enabledFolders], [enableAllFolders], [invalidLoginAttemptCount],
/// [loginAttemptsBeforeLockout], [enablePublicSharing], [blockedMediaFolders],
/// [blockedChannels], [remoteClientBitrateLimit], [authenticationProviderId],
/// [passwordResetProviderId] and [syncPlayAccess],
///
///
/// [Configuration]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class Policy with _$Policy {
  const factory Policy(
      {required bool isAdministrator,
      required bool isHidden,
      required bool isDisabled,
      int? maxParentalRating,
      @Default(<String>[]) List<String> blockedTags,
      required bool enableUserPreferenceAccess,
      @Default([]) List<dynamic> accessSchedules,
      @Default([]) List<dynamic> blockUnratedItems,
      required bool enableRemoteControlOfOtherUsers,
      required bool enableSharedDeviceControl,
      required bool enableRemoteAccess,
      required bool enableLiveTvManagement,
      required bool enableLiveTvAccess,
      required bool enableMediaPlayback,
      required bool enableAudioPlaybackTranscoding,
      required bool enableVideoPlaybackTranscoding,
      required bool enablePlaybackRemuxing,
      required bool forceRemoteSourceTranscoding,
      required bool enableContentDeletion,
      @Default(<String>[]) List<String> enableContentDeletionFromFolders,
      required bool enableContentDownloading,
      required bool enableSyncTranscoding,
      required bool enableMediaConversion,
      required bool enableAllDevices,
      required bool enableAllChannels,
      required bool enableAllFolders,
      required bool enablePublicSharing,
      required int invalidLoginAttemptCount,
      required int loginAttemptsBeforeLockout,
      @Default(<String>[]) List<String> enabledDevices,
      @Default(<String>[]) List<String> enabledChannels,
      @Default(<String>[]) List<String> enabledFolders,
      @Default(<String>[]) List<String> blockedMediaFolders,
      @Default(<String>[]) List<String> blockedChannels,
      required int remoteClientBitrateLimit,
      String? authenticationProviderId,
      String? passwordResetProviderId,
      SyncPlayAccess? syncPlayAccess}) = _Policy;

  /// Deserializes the given [JsonMap] into a [Configuration].
  factory Policy.fromJson(Map<String, Object?> json) => _$PolicyFromJson(json);
}
