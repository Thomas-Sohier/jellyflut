import 'package:jellyflut/models/playState.dart';

import 'capabilities.dart';

class SessionInfo {
  SessionInfo({
    this.playState,
    this.additionalUsers,
    this.capabilities,
    this.remoteEndPoint,
    this.playableMediaTypes,
    this.id,
    this.userId,
    this.userName,
    this.client,
    this.lastActivityDate,
    this.lastPlaybackCheckIn,
    this.deviceName,
    this.deviceId,
    this.applicationVersion,
    this.isActive,
    this.supportsMediaControl,
    this.supportsRemoteControl,
    this.hasCustomDeviceName,
    this.serverId,
    this.userPrimaryImageTag,
    this.supportedCommands,
  });

  PlayState playState;
  List<dynamic> additionalUsers;
  Capabilities capabilities;
  String remoteEndPoint;
  List<dynamic> playableMediaTypes;
  String id;
  String userId;
  String userName;
  String client;
  DateTime lastActivityDate;
  DateTime lastPlaybackCheckIn;
  String deviceName;
  String deviceId;
  String applicationVersion;
  bool isActive;
  bool supportsMediaControl;
  bool supportsRemoteControl;
  bool hasCustomDeviceName;
  String serverId;
  String userPrimaryImageTag;
  List<dynamic> supportedCommands;

  factory SessionInfo.fromMap(Map<String, dynamic> json) => SessionInfo(
        playState: PlayState.fromMap(json["PlayState"]),
        additionalUsers:
            List<dynamic>.from(json["AdditionalUsers"].map((x) => x)),
        capabilities: Capabilities.fromMap(json["Capabilities"]),
        remoteEndPoint: json["RemoteEndPoint"],
        playableMediaTypes:
            List<dynamic>.from(json["PlayableMediaTypes"].map((x) => x)),
        id: json["Id"],
        userId: json["UserId"],
        userName: json["UserName"],
        client: json["Client"],
        lastActivityDate: DateTime.parse(json["LastActivityDate"]),
        lastPlaybackCheckIn: DateTime.parse(json["LastPlaybackCheckIn"]),
        deviceName: json["DeviceName"],
        deviceId: json["DeviceId"],
        applicationVersion: json["ApplicationVersion"],
        isActive: json["IsActive"],
        supportsMediaControl: json["SupportsMediaControl"],
        supportsRemoteControl: json["SupportsRemoteControl"],
        hasCustomDeviceName: json["HasCustomDeviceName"],
        serverId: json["ServerId"],
        userPrimaryImageTag: json["UserPrimaryImageTag"],
        supportedCommands:
            List<dynamic>.from(json["SupportedCommands"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "PlayState": playState.toMap(),
        "AdditionalUsers": List<dynamic>.from(additionalUsers.map((x) => x)),
        "Capabilities": capabilities.toMap(),
        "RemoteEndPoint": remoteEndPoint,
        "PlayableMediaTypes":
            List<dynamic>.from(playableMediaTypes.map((x) => x)),
        "Id": id,
        "UserId": userId,
        "UserName": userName,
        "Client": client,
        "LastActivityDate": lastActivityDate.toIso8601String(),
        "LastPlaybackCheckIn": lastPlaybackCheckIn.toIso8601String(),
        "DeviceName": deviceName,
        "DeviceId": deviceId,
        "ApplicationVersion": applicationVersion,
        "IsActive": isActive,
        "SupportsMediaControl": supportsMediaControl,
        "SupportsRemoteControl": supportsRemoteControl,
        "HasCustomDeviceName": hasCustomDeviceName,
        "ServerId": serverId,
        "UserPrimaryImageTag": userPrimaryImageTag,
        "SupportedCommands":
            List<dynamic>.from(supportedCommands.map((x) => x)),
      };
}
