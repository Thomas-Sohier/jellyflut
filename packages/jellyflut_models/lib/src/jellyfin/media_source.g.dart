// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaSource _$$_MediaSourceFromJson(Map<String, dynamic> json) =>
    _$_MediaSource(
      protocol: $enumDecode(_$ProtocolEnumMap, json['protocol']),
      id: json['id'] as String?,
      path: json['path'] as String?,
      encoderPath: json['encoderPath'] as String?,
      encoderProtocol:
          $enumDecodeNullable(_$ProtocolEnumMap, json['encoderProtocol']),
      type: $enumDecode(_$MediaSourceTypeEnumMap, json['type']),
      container: json['container'] as String?,
      size: json['size'] as int?,
      name: json['name'] as String?,
      isRemote: json['isRemote'] as bool,
      eTag: json['eTag'] as String?,
      runTimeTicks: json['runTimeTicks'] as int?,
      readAtNativeFramerate: json['readAtNativeFramerate'] as bool,
      ignoreDts: json['ignoreDts'] as bool,
      ignoreIndex: json['ignoreIndex'] as bool,
      genPtsInput: json['genPtsInput'] as bool,
      supportsTranscoding: json['supportsTranscoding'] as bool,
      supportsDirectStream: json['supportsDirectStream'] as bool,
      supportsDirectPlay: json['supportsDirectPlay'] as bool,
      isInfiniteStream: json['isInfiniteStream'] as bool,
      requiresOpening: json['requiresOpening'] as bool,
      openToken: json['openToken'] as String?,
      requiresClosing: json['requiresClosing'] as bool,
      liveStreamId: json['liveStreamId'] as String?,
      bufferMs: json['bufferMs'] as int?,
      requiresLooping: json['requiresLooping'] as bool,
      supportsProbing: json['supportsProbing'] as bool,
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['videoType']),
      isoType: $enumDecodeNullable(_$IsoTypeEnumMap, json['isoType']),
      video3DFormat:
          $enumDecodeNullable(_$Video3DFormatEnumMap, json['video3DFormat']),
      mediaStreams: (json['mediaStreams'] as List<dynamic>?)
              ?.map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaStream>[],
      mediaAttachments: (json['mediaAttachments'] as List<dynamic>?)
              ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaAttachment>[],
      formats: (json['formats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      bitrate: json['bitrate'] as int?,
      timestamp: $enumDecodeNullable(_$TimestampEnumMap, json['timestamp']),
      requiredHttpHeaders:
          (json['requiredHttpHeaders'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const <String, String>{},
      transcodingUrl: json['transcodingUrl'] as String?,
      transcodingSubProtocol: json['transcodingSubProtocol'] as String?,
      transcodingContainer: json['transcodingContainer'] as String?,
      analyzeDurationMs: json['analyzeDurationMs'] as int?,
      defaultAudioStreamIndex: json['defaultAudioStreamIndex'] as int?,
      defaultSubtitleStreamIndex: json['defaultSubtitleStreamIndex'] as int?,
    );

Map<String, dynamic> _$$_MediaSourceToJson(_$_MediaSource instance) =>
    <String, dynamic>{
      'protocol': _$ProtocolEnumMap[instance.protocol],
      'id': instance.id,
      'path': instance.path,
      'encoderPath': instance.encoderPath,
      'encoderProtocol': _$ProtocolEnumMap[instance.encoderProtocol],
      'type': _$MediaSourceTypeEnumMap[instance.type],
      'container': instance.container,
      'size': instance.size,
      'name': instance.name,
      'isRemote': instance.isRemote,
      'eTag': instance.eTag,
      'runTimeTicks': instance.runTimeTicks,
      'readAtNativeFramerate': instance.readAtNativeFramerate,
      'ignoreDts': instance.ignoreDts,
      'ignoreIndex': instance.ignoreIndex,
      'genPtsInput': instance.genPtsInput,
      'supportsTranscoding': instance.supportsTranscoding,
      'supportsDirectStream': instance.supportsDirectStream,
      'supportsDirectPlay': instance.supportsDirectPlay,
      'isInfiniteStream': instance.isInfiniteStream,
      'requiresOpening': instance.requiresOpening,
      'openToken': instance.openToken,
      'requiresClosing': instance.requiresClosing,
      'liveStreamId': instance.liveStreamId,
      'bufferMs': instance.bufferMs,
      'requiresLooping': instance.requiresLooping,
      'supportsProbing': instance.supportsProbing,
      'videoType': _$VideoTypeEnumMap[instance.videoType],
      'isoType': _$IsoTypeEnumMap[instance.isoType],
      'video3DFormat': _$Video3DFormatEnumMap[instance.video3DFormat],
      'mediaStreams': instance.mediaStreams,
      'mediaAttachments': instance.mediaAttachments,
      'formats': instance.formats,
      'bitrate': instance.bitrate,
      'timestamp': _$TimestampEnumMap[instance.timestamp],
      'requiredHttpHeaders': instance.requiredHttpHeaders,
      'transcodingUrl': instance.transcodingUrl,
      'transcodingSubProtocol': instance.transcodingSubProtocol,
      'transcodingContainer': instance.transcodingContainer,
      'analyzeDurationMs': instance.analyzeDurationMs,
      'defaultAudioStreamIndex': instance.defaultAudioStreamIndex,
      'defaultSubtitleStreamIndex': instance.defaultSubtitleStreamIndex,
    };

const _$ProtocolEnumMap = {
  Protocol.File: 'File',
  Protocol.Http: 'Http',
  Protocol.Rtmp: 'Rtmp',
  Protocol.Rtsp: 'Rtsp',
  Protocol.Udp: 'Udp',
  Protocol.Rtp: 'Rtp',
  Protocol.Ftp: 'Ftp',
};

const _$MediaSourceTypeEnumMap = {
  MediaSourceType.Default: 'Default',
  MediaSourceType.Grouping: 'Grouping',
  MediaSourceType.Placeholder: 'Placeholder',
};

const _$VideoTypeEnumMap = {
  VideoType.VideoFile: 'VideoFile',
  VideoType.Iso: 'Iso',
  VideoType.Dvd: 'Dvd',
  VideoType.BluRay: 'BluRay',
};

const _$IsoTypeEnumMap = {
  IsoType.Dvd: 'Dvd',
  IsoType.BluRay: 'BluRay',
};

const _$Video3DFormatEnumMap = {
  Video3DFormat.HalfSideBySide: 'HalfSideBySide',
  Video3DFormat.FullSideBySide: 'FullSideBySide',
  Video3DFormat.FullTopAndBottom: 'FullTopAndBottom',
  Video3DFormat.HalfTopAndBottom: 'HalfTopAndBottom',
  Video3DFormat.MVC: 'MVC',
};

const _$TimestampEnumMap = {
  Timestamp.None: 'None',
  Timestamp.Zero: 'Zero',
  Timestamp.Valid: 'Valid',
};
