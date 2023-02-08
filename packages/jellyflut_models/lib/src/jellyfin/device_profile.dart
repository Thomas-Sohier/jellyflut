import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'index.dart';

class DeviceProfile {
  String? name;
  String? id;
  Identification? identification;
  String? friendlyName;
  String? manufacturer;
  String? manufacturerUrl;
  String? modelName;
  String? modelDescription;
  String? modelNumber;
  String? modelUrl;
  String? serialNumber;
  bool enableAlbumArtInDidl;
  bool enableSingleAlbumArtLimit;
  bool enableSingleSubtitleLimit;
  String? supportedMediaTypes;
  String? userId;
  String? albumArtPn;
  int? maxAlbumArtWidth;
  int? maxAlbumArtHeight;
  int? maxIconWidth;
  int? maxIconHeight;
  int? maxStreamingBitrate;
  int? maxStaticBitrate;
  int? musicStreamingTranscodingBitrate;
  int? maxStaticMusicBitrate;
  String? sonyAggregationFlags;
  String? protocolInfo;
  int timelineOffsetSeconds;
  bool requiresPlainVideoItems;
  bool requiresPlainFolders;
  bool enableMSMediaReceiverRegistrar;
  bool ignoreTranscodeByteRangeRequests;
  List<dynamic>? xmlRootAttributes;
  List<DirectPlayProfile>? directPlayProfiles;
  List<TranscodingProfile>? transcodingProfiles;
  List<dynamic>? containerProfiles;
  List<CodecProfile>? codecProfiles;
  List<ResponseProfile>? responseProfiles;
  List<SubtitleProfile>? subtitleProfiles;

  DeviceProfile({
    this.name,
    this.id,
    this.identification,
    this.friendlyName,
    this.manufacturer,
    this.manufacturerUrl,
    this.modelName,
    this.modelDescription,
    this.modelNumber,
    this.modelUrl,
    this.serialNumber,
    this.enableAlbumArtInDidl = true,
    this.enableSingleAlbumArtLimit = true,
    this.enableSingleSubtitleLimit = true,
    this.supportedMediaTypes,
    this.userId,
    this.albumArtPn,
    this.maxAlbumArtWidth,
    this.maxAlbumArtHeight,
    this.maxIconWidth,
    this.maxIconHeight,
    this.maxStreamingBitrate,
    this.maxStaticBitrate,
    this.musicStreamingTranscodingBitrate,
    this.maxStaticMusicBitrate,
    this.sonyAggregationFlags,
    this.protocolInfo,
    this.timelineOffsetSeconds = 0,
    this.requiresPlainVideoItems = true,
    this.requiresPlainFolders = true,
    this.enableMSMediaReceiverRegistrar = true,
    this.ignoreTranscodeByteRangeRequests = true,
    this.xmlRootAttributes = const [],
    this.directPlayProfiles = const [],
    this.transcodingProfiles = const [],
    this.containerProfiles = const [],
    this.codecProfiles = const [],
    this.responseProfiles = const [],
    this.subtitleProfiles = const [],
  });

  DeviceProfile copyWith({
    String? name,
    String? id,
    Identification? identification,
    String? friendlyName,
    String? manufacturer,
    String? manufacturerUrl,
    String? modelName,
    String? modelDescription,
    String? modelNumber,
    String? modelUrl,
    String? serialNumber,
    bool? enableAlbumArtInDidl,
    bool? enableSingleAlbumArtLimit,
    bool? enableSingleSubtitleLimit,
    String? supportedMediaTypes,
    String? userId,
    String? albumArtPn,
    int? maxAlbumArtWidth,
    int? maxAlbumArtHeight,
    int? maxIconWidth,
    int? maxIconHeight,
    int? maxStreamingBitrate,
    int? maxStaticBitrate,
    int? musicStreamingTranscodingBitrate,
    int? maxStaticMusicBitrate,
    String? sonyAggregationFlags,
    String? protocolInfo,
    int? timelineOffsetSeconds,
    bool? requiresPlainVideoItems,
    bool? requiresPlainFolders,
    bool? enableMSMediaReceiverRegistrar,
    bool? ignoreTranscodeByteRangeRequests,
    List<dynamic>? xmlRootAttributes,
    List<DirectPlayProfile>? directPlayProfiles,
    List<TranscodingProfile>? transcodingProfiles,
    List<dynamic>? containerProfiles,
    List<CodecProfile>? codecProfiles,
    List<ResponseProfile>? responseProfiles,
    List<SubtitleProfile>? subtitleProfiles,
  }) {
    return DeviceProfile(
      name: name ?? this.name,
      id: id ?? this.id,
      identification: identification ?? this.identification,
      friendlyName: friendlyName ?? this.friendlyName,
      manufacturer: manufacturer ?? this.manufacturer,
      manufacturerUrl: manufacturerUrl ?? this.manufacturerUrl,
      modelName: modelName ?? this.modelName,
      modelDescription: modelDescription ?? this.modelDescription,
      modelNumber: modelNumber ?? this.modelNumber,
      modelUrl: modelUrl ?? this.modelUrl,
      serialNumber: serialNumber ?? this.serialNumber,
      enableAlbumArtInDidl: enableAlbumArtInDidl ?? this.enableAlbumArtInDidl,
      enableSingleAlbumArtLimit: enableSingleAlbumArtLimit ?? this.enableSingleAlbumArtLimit,
      enableSingleSubtitleLimit: enableSingleSubtitleLimit ?? this.enableSingleSubtitleLimit,
      supportedMediaTypes: supportedMediaTypes ?? this.supportedMediaTypes,
      userId: userId ?? this.userId,
      albumArtPn: albumArtPn ?? this.albumArtPn,
      maxAlbumArtWidth: maxAlbumArtWidth ?? this.maxAlbumArtWidth,
      maxAlbumArtHeight: maxAlbumArtHeight ?? this.maxAlbumArtHeight,
      maxIconWidth: maxIconWidth ?? this.maxIconWidth,
      maxIconHeight: maxIconHeight ?? this.maxIconHeight,
      maxStreamingBitrate: maxStreamingBitrate ?? this.maxStreamingBitrate,
      maxStaticBitrate: maxStaticBitrate ?? this.maxStaticBitrate,
      musicStreamingTranscodingBitrate: musicStreamingTranscodingBitrate ?? this.musicStreamingTranscodingBitrate,
      maxStaticMusicBitrate: maxStaticMusicBitrate ?? this.maxStaticMusicBitrate,
      sonyAggregationFlags: sonyAggregationFlags ?? this.sonyAggregationFlags,
      protocolInfo: protocolInfo ?? this.protocolInfo,
      timelineOffsetSeconds: timelineOffsetSeconds ?? this.timelineOffsetSeconds,
      requiresPlainVideoItems: requiresPlainVideoItems ?? this.requiresPlainVideoItems,
      requiresPlainFolders: requiresPlainFolders ?? this.requiresPlainFolders,
      enableMSMediaReceiverRegistrar: enableMSMediaReceiverRegistrar ?? this.enableMSMediaReceiverRegistrar,
      ignoreTranscodeByteRangeRequests: ignoreTranscodeByteRangeRequests ?? this.ignoreTranscodeByteRangeRequests,
      xmlRootAttributes: xmlRootAttributes ?? this.xmlRootAttributes,
      directPlayProfiles: directPlayProfiles ?? this.directPlayProfiles,
      transcodingProfiles: transcodingProfiles ?? this.transcodingProfiles,
      containerProfiles: containerProfiles ?? this.containerProfiles,
      codecProfiles: codecProfiles ?? this.codecProfiles,
      responseProfiles: responseProfiles ?? this.responseProfiles,
      subtitleProfiles: subtitleProfiles ?? this.subtitleProfiles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'identification': identification?.toMap(),
      'friendlyName': friendlyName,
      'manufacturer': manufacturer,
      'manufacturerUrl': manufacturerUrl,
      'modelName': modelName,
      'modelDescription': modelDescription,
      'modelNumber': modelNumber,
      'modelUrl': modelUrl,
      'serialNumber': serialNumber,
      'enableAlbumArtInDidl': enableAlbumArtInDidl,
      'enableSingleAlbumArtLimit': enableSingleAlbumArtLimit,
      'enableSingleSubtitleLimit': enableSingleSubtitleLimit,
      'supportedMediaTypes': supportedMediaTypes,
      'userId': userId,
      'albumArtPn': albumArtPn,
      'maxAlbumArtWidth': maxAlbumArtWidth,
      'maxAlbumArtHeight': maxAlbumArtHeight,
      'maxIconWidth': maxIconWidth,
      'maxIconHeight': maxIconHeight,
      'maxStreamingBitrate': maxStreamingBitrate,
      'maxStaticBitrate': maxStaticBitrate,
      'musicStreamingTranscodingBitrate': musicStreamingTranscodingBitrate,
      'maxStaticMusicBitrate': maxStaticMusicBitrate,
      'sonyAggregationFlags': sonyAggregationFlags,
      'protocolInfo': protocolInfo,
      'timelineOffsetSeconds': timelineOffsetSeconds,
      'requiresPlainVideoItems': requiresPlainVideoItems,
      'requiresPlainFolders': requiresPlainFolders,
      'enableMSMediaReceiverRegistrar': enableMSMediaReceiverRegistrar,
      'ignoreTranscodeByteRangeRequests': ignoreTranscodeByteRangeRequests,
      'xmlRootAttributes': xmlRootAttributes,
      'directPlayProfiles': directPlayProfiles?.map((x) => x.toMap()).toList(),
      'transcodingProfiles': transcodingProfiles?.map((x) => x.toMap()).toList(),
      'containerProfiles': containerProfiles,
      'codecProfiles': codecProfiles?.map((x) => x.toMap()).toList(),
      'responseProfiles': responseProfiles?.map((x) => x.toMap()).toList(),
      'subtitleProfiles': subtitleProfiles?.map((x) => x.toMap()).toList(),
    }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
  }

  factory DeviceProfile.fromMap(Map<String, dynamic> map) {
    return DeviceProfile(
      name: map['name'],
      id: map['id'],
      identification: map['identification'] != null ? Identification.fromMap(map['identification']) : null,
      friendlyName: map['friendlyName'],
      manufacturer: map['manufacturer'],
      manufacturerUrl: map['manufacturerUrl'],
      modelName: map['modelName'],
      modelDescription: map['modelDescription'],
      modelNumber: map['modelNumber'],
      modelUrl: map['modelUrl'],
      serialNumber: map['serialNumber'],
      enableAlbumArtInDidl: map['enableAlbumArtInDidl'] ?? false,
      enableSingleAlbumArtLimit: map['enableSingleAlbumArtLimit'] ?? false,
      enableSingleSubtitleLimit: map['enableSingleSubtitleLimit'] ?? false,
      supportedMediaTypes: map['supportedMediaTypes'],
      userId: map['userId'],
      albumArtPn: map['albumArtPn'],
      maxAlbumArtWidth: map['maxAlbumArtWidth']?.toInt(),
      maxAlbumArtHeight: map['maxAlbumArtHeight']?.toInt(),
      maxIconWidth: map['maxIconWidth']?.toInt(),
      maxIconHeight: map['maxIconHeight']?.toInt(),
      maxStreamingBitrate: map['maxStreamingBitrate']?.toInt(),
      maxStaticBitrate: map['maxStaticBitrate']?.toInt(),
      musicStreamingTranscodingBitrate: map['musicStreamingTranscodingBitrate']?.toInt(),
      maxStaticMusicBitrate: map['maxStaticMusicBitrate']?.toInt(),
      sonyAggregationFlags: map['sonyAggregationFlags'],
      protocolInfo: map['protocolInfo'],
      timelineOffsetSeconds: map['timelineOffsetSeconds']?.toInt() ?? 0,
      requiresPlainVideoItems: map['requiresPlainVideoItems'] ?? false,
      requiresPlainFolders: map['requiresPlainFolders'] ?? false,
      enableMSMediaReceiverRegistrar: map['enableMSMediaReceiverRegistrar'] ?? false,
      ignoreTranscodeByteRangeRequests: map['ignoreTranscodeByteRangeRequests'] ?? false,
      xmlRootAttributes: List<dynamic>.from(map['xmlRootAttributes']),
      directPlayProfiles: map['directPlayProfiles'] != null
          ? List<DirectPlayProfile>.from(map['directPlayProfiles']?.map((x) => DirectPlayProfile.fromMap(x)))
          : null,
      transcodingProfiles: map['transcodingProfiles'] != null
          ? List<TranscodingProfile>.from(map['transcodingProfiles']?.map((x) => TranscodingProfile.fromMap(x)))
          : null,
      containerProfiles: List<dynamic>.from(map['containerProfiles']),
      codecProfiles: map['codecProfiles'] != null
          ? List<CodecProfile>.from(map['codecProfiles']?.map((x) => CodecProfile.fromMap(x)))
          : null,
      responseProfiles: map['responseProfiles'] != null
          ? List<ResponseProfile>.from(map['responseProfiles']?.map((x) => ResponseProfile.fromMap(x)))
          : null,
      subtitleProfiles: map['subtitleProfiles'] != null
          ? List<SubtitleProfile>.from(map['subtitleProfiles']?.map((x) => SubtitleProfile.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceProfile.fromJson(String source) => DeviceProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeviceProfile(name: $name, id: $id, identification: $identification, friendlyName: $friendlyName, manufacturer: $manufacturer, manufacturerUrl: $manufacturerUrl, modelName: $modelName, modelDescription: $modelDescription, modelNumber: $modelNumber, modelUrl: $modelUrl, serialNumber: $serialNumber, enableAlbumArtInDidl: $enableAlbumArtInDidl, enableSingleAlbumArtLimit: $enableSingleAlbumArtLimit, enableSingleSubtitleLimit: $enableSingleSubtitleLimit, supportedMediaTypes: $supportedMediaTypes, userId: $userId, albumArtPn: $albumArtPn, maxAlbumArtWidth: $maxAlbumArtWidth, maxAlbumArtHeight: $maxAlbumArtHeight, maxIconWidth: $maxIconWidth, maxIconHeight: $maxIconHeight, maxStreamingBitrate: $maxStreamingBitrate, maxStaticBitrate: $maxStaticBitrate, musicStreamingTranscodingBitrate: $musicStreamingTranscodingBitrate, maxStaticMusicBitrate: $maxStaticMusicBitrate, sonyAggregationFlags: $sonyAggregationFlags, protocolInfo: $protocolInfo, timelineOffsetSeconds: $timelineOffsetSeconds, requiresPlainVideoItems: $requiresPlainVideoItems, requiresPlainFolders: $requiresPlainFolders, enableMSMediaReceiverRegistrar: $enableMSMediaReceiverRegistrar, ignoreTranscodeByteRangeRequests: $ignoreTranscodeByteRangeRequests, xmlRootAttributes: $xmlRootAttributes, directPlayProfiles: $directPlayProfiles, transcodingProfiles: $transcodingProfiles, containerProfiles: $containerProfiles, codecProfiles: $codecProfiles, responseProfiles: $responseProfiles, subtitleProfiles: $subtitleProfiles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceProfile &&
        other.name == name &&
        other.id == id &&
        other.identification == identification &&
        other.friendlyName == friendlyName &&
        other.manufacturer == manufacturer &&
        other.manufacturerUrl == manufacturerUrl &&
        other.modelName == modelName &&
        other.modelDescription == modelDescription &&
        other.modelNumber == modelNumber &&
        other.modelUrl == modelUrl &&
        other.serialNumber == serialNumber &&
        other.enableAlbumArtInDidl == enableAlbumArtInDidl &&
        other.enableSingleAlbumArtLimit == enableSingleAlbumArtLimit &&
        other.enableSingleSubtitleLimit == enableSingleSubtitleLimit &&
        other.supportedMediaTypes == supportedMediaTypes &&
        other.userId == userId &&
        other.albumArtPn == albumArtPn &&
        other.maxAlbumArtWidth == maxAlbumArtWidth &&
        other.maxAlbumArtHeight == maxAlbumArtHeight &&
        other.maxIconWidth == maxIconWidth &&
        other.maxIconHeight == maxIconHeight &&
        other.maxStreamingBitrate == maxStreamingBitrate &&
        other.maxStaticBitrate == maxStaticBitrate &&
        other.musicStreamingTranscodingBitrate == musicStreamingTranscodingBitrate &&
        other.maxStaticMusicBitrate == maxStaticMusicBitrate &&
        other.sonyAggregationFlags == sonyAggregationFlags &&
        other.protocolInfo == protocolInfo &&
        other.timelineOffsetSeconds == timelineOffsetSeconds &&
        other.requiresPlainVideoItems == requiresPlainVideoItems &&
        other.requiresPlainFolders == requiresPlainFolders &&
        other.enableMSMediaReceiverRegistrar == enableMSMediaReceiverRegistrar &&
        other.ignoreTranscodeByteRangeRequests == ignoreTranscodeByteRangeRequests &&
        listEquals(other.xmlRootAttributes, xmlRootAttributes) &&
        listEquals(other.directPlayProfiles, directPlayProfiles) &&
        listEquals(other.transcodingProfiles, transcodingProfiles) &&
        listEquals(other.containerProfiles, containerProfiles) &&
        listEquals(other.codecProfiles, codecProfiles) &&
        listEquals(other.responseProfiles, responseProfiles) &&
        listEquals(other.subtitleProfiles, subtitleProfiles);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        identification.hashCode ^
        friendlyName.hashCode ^
        manufacturer.hashCode ^
        manufacturerUrl.hashCode ^
        modelName.hashCode ^
        modelDescription.hashCode ^
        modelNumber.hashCode ^
        modelUrl.hashCode ^
        serialNumber.hashCode ^
        enableAlbumArtInDidl.hashCode ^
        enableSingleAlbumArtLimit.hashCode ^
        enableSingleSubtitleLimit.hashCode ^
        supportedMediaTypes.hashCode ^
        userId.hashCode ^
        albumArtPn.hashCode ^
        maxAlbumArtWidth.hashCode ^
        maxAlbumArtHeight.hashCode ^
        maxIconWidth.hashCode ^
        maxIconHeight.hashCode ^
        maxStreamingBitrate.hashCode ^
        maxStaticBitrate.hashCode ^
        musicStreamingTranscodingBitrate.hashCode ^
        maxStaticMusicBitrate.hashCode ^
        sonyAggregationFlags.hashCode ^
        protocolInfo.hashCode ^
        timelineOffsetSeconds.hashCode ^
        requiresPlainVideoItems.hashCode ^
        requiresPlainFolders.hashCode ^
        enableMSMediaReceiverRegistrar.hashCode ^
        ignoreTranscodeByteRangeRequests.hashCode ^
        xmlRootAttributes.hashCode ^
        directPlayProfiles.hashCode ^
        transcodingProfiles.hashCode ^
        containerProfiles.hashCode ^
        codecProfiles.hashCode ^
        responseProfiles.hashCode ^
        subtitleProfiles.hashCode;
  }
}
