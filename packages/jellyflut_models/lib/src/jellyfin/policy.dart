class Policy {
  Policy({
    this.isAdministrator,
    this.isHidden,
    this.isDisabled,
    this.blockedTags,
    this.enableUserPreferenceAccess,
    this.accessSchedules,
    this.blockUnratedItems,
    this.enableRemoteControlOfOtherUsers,
    this.enableSharedDeviceControl,
    this.enableRemoteAccess,
    this.enableLiveTvManagement,
    this.enableLiveTvAccess,
    this.enableMediaPlayback,
    this.enableAudioPlaybackTranscoding,
    this.enableVideoPlaybackTranscoding,
    this.enablePlaybackRemuxing,
    this.forceRemoteSourceTranscoding,
    this.enableContentDeletion,
    this.enableContentDeletionFromFolders,
    this.enableContentDownloading,
    this.enableSyncTranscoding,
    this.enableMediaConversion,
    this.enabledDevices,
    this.enableAllDevices,
    this.enabledChannels,
    this.enableAllChannels,
    this.enabledFolders,
    this.enableAllFolders,
    this.invalidLoginAttemptCount,
    this.loginAttemptsBeforeLockout,
    this.enablePublicSharing,
    this.blockedMediaFolders,
    this.blockedChannels,
    this.remoteClientBitrateLimit,
    this.authenticationProviderId,
    this.passwordResetProviderId,
    this.syncPlayAccess,
  });

  bool? isAdministrator;
  bool? isHidden;
  bool? isDisabled;
  List<dynamic>? blockedTags;
  bool? enableUserPreferenceAccess;
  List<dynamic>? accessSchedules;
  List<dynamic>? blockUnratedItems;
  bool? enableRemoteControlOfOtherUsers;
  bool? enableSharedDeviceControl;
  bool? enableRemoteAccess;
  bool? enableLiveTvManagement;
  bool? enableLiveTvAccess;
  bool? enableMediaPlayback;
  bool? enableAudioPlaybackTranscoding;
  bool? enableVideoPlaybackTranscoding;
  bool? enablePlaybackRemuxing;
  bool? forceRemoteSourceTranscoding;
  bool? enableContentDeletion;
  List<dynamic>? enableContentDeletionFromFolders;
  bool? enableContentDownloading;
  bool? enableSyncTranscoding;
  bool? enableMediaConversion;
  List<dynamic>? enabledDevices;
  bool? enableAllDevices;
  List<dynamic>? enabledChannels;
  bool? enableAllChannels;
  List<dynamic>? enabledFolders;
  bool? enableAllFolders;
  int? invalidLoginAttemptCount;
  int? loginAttemptsBeforeLockout;
  bool? enablePublicSharing;
  List<dynamic>? blockedMediaFolders;
  List<dynamic>? blockedChannels;
  int? remoteClientBitrateLimit;
  String? authenticationProviderId;
  String? passwordResetProviderId;
  String? syncPlayAccess;

  factory Policy.fromMap(Map<String, dynamic> json) => Policy(
        isAdministrator: json['IsAdministrator'],
        isHidden: json['IsHidden'],
        isDisabled: json['IsDisabled'],
        blockedTags: List<dynamic>.from(json['BlockedTags'].map((x) => x)),
        enableUserPreferenceAccess: json['EnableUserPreferenceAccess'],
        accessSchedules: List<dynamic>.from(json['AccessSchedules'].map((x) => x)),
        blockUnratedItems: List<dynamic>.from(json['BlockUnratedItems'].map((x) => x)),
        enableRemoteControlOfOtherUsers: json['EnableRemoteControlOfOtherUsers'],
        enableSharedDeviceControl: json['EnableSharedDeviceControl'],
        enableRemoteAccess: json['EnableRemoteAccess'],
        enableLiveTvManagement: json['EnableLiveTvManagement'],
        enableLiveTvAccess: json['EnableLiveTvAccess'],
        enableMediaPlayback: json['EnableMediaPlayback'],
        enableAudioPlaybackTranscoding: json['EnableAudioPlaybackTranscoding'],
        enableVideoPlaybackTranscoding: json['EnableVideoPlaybackTranscoding'],
        enablePlaybackRemuxing: json['EnablePlaybackRemuxing'],
        forceRemoteSourceTranscoding: json['ForceRemoteSourceTranscoding'],
        enableContentDeletion: json['EnableContentDeletion'],
        enableContentDeletionFromFolders: List<dynamic>.from(json['EnableContentDeletionFromFolders'].map((x) => x)),
        enableContentDownloading: json['EnableContentDownloading'],
        enableSyncTranscoding: json['EnableSyncTranscoding'],
        enableMediaConversion: json['EnableMediaConversion'],
        enabledDevices: List<dynamic>.from(json['EnabledDevices'].map((x) => x)),
        enableAllDevices: json['EnableAllDevices'],
        enabledChannels: List<dynamic>.from(json['EnabledChannels'].map((x) => x)),
        enableAllChannels: json['EnableAllChannels'],
        enabledFolders: List<dynamic>.from(json['EnabledFolders'].map((x) => x)),
        enableAllFolders: json['EnableAllFolders'],
        invalidLoginAttemptCount: json['InvalidLoginAttemptCount'],
        loginAttemptsBeforeLockout: json['LoginAttemptsBeforeLockout'],
        enablePublicSharing: json['EnablePublicSharing'],
        blockedMediaFolders: List<dynamic>.from(json['BlockedMediaFolders'].map((x) => x)),
        blockedChannels: List<dynamic>.from(json['BlockedChannels'].map((x) => x)),
        remoteClientBitrateLimit: json['RemoteClientBitrateLimit'],
        authenticationProviderId: json['AuthenticationProviderId'],
        passwordResetProviderId: json['PasswordResetProviderId'],
        syncPlayAccess: json['SyncPlayAccess'],
      );

  Map<String, dynamic> toMap() => {
        'IsAdministrator': isAdministrator,
        'IsHidden': isHidden,
        'IsDisabled': isDisabled,
        'BlockedTags': blockedTags != null ? List<dynamic>.from(blockedTags!.map((x) => x)) : null,
        'EnableUserPreferenceAccess': enableUserPreferenceAccess,
        'AccessSchedules': accessSchedules != null ? List<dynamic>.from(accessSchedules!.map((x) => x)) : null,
        'BlockUnratedItems': blockUnratedItems != null ? List<dynamic>.from(blockUnratedItems!.map((x) => x)) : null,
        'EnableRemoteControlOfOtherUsers': enableRemoteControlOfOtherUsers,
        'EnableSharedDeviceControl': enableSharedDeviceControl,
        'EnableRemoteAccess': enableRemoteAccess,
        'EnableLiveTvManagement': enableLiveTvManagement,
        'EnableLiveTvAccess': enableLiveTvAccess,
        'EnableMediaPlayback': enableMediaPlayback,
        'EnableAudioPlaybackTranscoding': enableAudioPlaybackTranscoding,
        'EnableVideoPlaybackTranscoding': enableVideoPlaybackTranscoding,
        'EnablePlaybackRemuxing': enablePlaybackRemuxing,
        'ForceRemoteSourceTranscoding': forceRemoteSourceTranscoding,
        'EnableContentDeletion': enableContentDeletion,
        'EnableContentDeletionFromFolders': enableContentDeletionFromFolders != null
            ? List<dynamic>.from(enableContentDeletionFromFolders!.map((x) => x))
            : null,
        'EnableContentDownloading': enableContentDownloading,
        'EnableSyncTranscoding': enableSyncTranscoding,
        'EnableMediaConversion': enableMediaConversion,
        'EnabledDevices': enabledDevices != null ? List<dynamic>.from(enabledDevices!.map((x) => x)) : null,
        'EnableAllDevices': enableAllDevices,
        'EnabledChannels': enabledChannels != null ? List<dynamic>.from(enabledChannels!.map((x) => x)) : null,
        'EnableAllChannels': enableAllChannels,
        'EnabledFolders': enabledFolders != null ? List<dynamic>.from(enabledFolders!.map((x) => x)) : null,
        'EnableAllFolders': enableAllFolders,
        'InvalidLoginAttemptCount': invalidLoginAttemptCount,
        'LoginAttemptsBeforeLockout': loginAttemptsBeforeLockout,
        'EnablePublicSharing': enablePublicSharing,
        'BlockedMediaFolders':
            blockedMediaFolders != null ? List<dynamic>.from(blockedMediaFolders!.map((x) => x)) : null,
        'BlockedChannels': blockedChannels != null ? List<dynamic>.from(blockedChannels!.map((x) => x)) : null,
        'RemoteClientBitrateLimit': remoteClientBitrateLimit,
        'AuthenticationProviderId': authenticationProviderId,
        'PasswordResetProviderId': passwordResetProviderId,
        'SyncPlayAccess': syncPlayAccess,
      };
}
