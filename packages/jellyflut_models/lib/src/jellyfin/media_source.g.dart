// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaSource _$$_MediaSourceFromJson(Map<String, dynamic> json) =>
    _$_MediaSource(
      protocol: $enumDecode(_$ProtocolEnumMap, json['Protocol']),
      id: json['Id'] as String?,
      path: json['Path'] as String?,
      encoderPath: json['EncoderPath'] as String?,
      encoderProtocol:
          $enumDecodeNullable(_$ProtocolEnumMap, json['EncoderProtocol']),
      type: $enumDecode(_$MediaSourceTypeEnumMap, json['Type']),
      container: json['Container'] as String?,
      size: json['Size'] as int?,
      name: json['Name'] as String?,
      isRemote: json['IsRemote'] as bool,
      eTag: json['ETag'] as String?,
      runTimeTicks: json['RunTimeTicks'] as int?,
      readAtNativeFramerate: json['ReadAtNativeFramerate'] as bool,
      ignoreDts: json['IgnoreDts'] as bool,
      ignoreIndex: json['IgnoreIndex'] as bool,
      genPtsInput: json['GenPtsInput'] as bool,
      supportsTranscoding: json['SupportsTranscoding'] as bool,
      supportsDirectStream: json['SupportsDirectStream'] as bool,
      supportsDirectPlay: json['SupportsDirectPlay'] as bool,
      isInfiniteStream: json['IsInfiniteStream'] as bool,
      requiresOpening: json['RequiresOpening'] as bool,
      openToken: json['OpenToken'] as String?,
      requiresClosing: json['RequiresClosing'] as bool,
      liveStreamId: json['LiveStreamId'] as String?,
      bufferMs: json['BufferMs'] as int?,
      requiresLooping: json['RequiresLooping'] as bool,
      supportsProbing: json['SupportsProbing'] as bool,
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['VideoType']),
      isoType: $enumDecodeNullable(_$IsoTypeEnumMap, json['IsoType']),
      video3DFormat:
          $enumDecodeNullable(_$Video3DFormatEnumMap, json['Video3DFormat']),
      mediaStreams: (json['MediaStreams'] as List<dynamic>?)
              ?.map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaStream>[],
      mediaAttachments: (json['MediaAttachments'] as List<dynamic>?)
              ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaAttachment>[],
      formats: (json['Formats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      bitrate: json['Bitrate'] as int?,
      timestamp: $enumDecodeNullable(_$TimestampEnumMap, json['Timestamp']),
      requiredHttpHeaders:
          (json['RequiredHttpHeaders'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const <String, String>{},
      transcodingUrl: json['TranscodingUrl'] as String?,
      transcodingSubProtocol: json['TranscodingSubProtocol'] as String?,
      transcodingContainer: json['TranscodingContainer'] as String?,
      analyzeDurationMs: json['AnalyzeDurationMs'] as int?,
      defaultAudioStreamIndex: json['DefaultAudioStreamIndex'] as int?,
      defaultSubtitleStreamIndex: json['DefaultSubtitleStreamIndex'] as int?,
    );

Map<String, dynamic> _$$_MediaSourceToJson(_$_MediaSource instance) {
  final val = <String, dynamic>{
    'Protocol': _$ProtocolEnumMap[instance.protocol]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Id', instance.id);
  writeNotNull('Path', instance.path);
  writeNotNull('EncoderPath', instance.encoderPath);
  writeNotNull('EncoderProtocol', _$ProtocolEnumMap[instance.encoderProtocol]);
  val['Type'] = _$MediaSourceTypeEnumMap[instance.type]!;
  writeNotNull('Container', instance.container);
  writeNotNull('Size', instance.size);
  writeNotNull('Name', instance.name);
  val['IsRemote'] = instance.isRemote;
  writeNotNull('ETag', instance.eTag);
  writeNotNull('RunTimeTicks', instance.runTimeTicks);
  val['ReadAtNativeFramerate'] = instance.readAtNativeFramerate;
  val['IgnoreDts'] = instance.ignoreDts;
  val['IgnoreIndex'] = instance.ignoreIndex;
  val['GenPtsInput'] = instance.genPtsInput;
  val['SupportsTranscoding'] = instance.supportsTranscoding;
  val['SupportsDirectStream'] = instance.supportsDirectStream;
  val['SupportsDirectPlay'] = instance.supportsDirectPlay;
  val['IsInfiniteStream'] = instance.isInfiniteStream;
  val['RequiresOpening'] = instance.requiresOpening;
  writeNotNull('OpenToken', instance.openToken);
  val['RequiresClosing'] = instance.requiresClosing;
  writeNotNull('LiveStreamId', instance.liveStreamId);
  writeNotNull('BufferMs', instance.bufferMs);
  val['RequiresLooping'] = instance.requiresLooping;
  val['SupportsProbing'] = instance.supportsProbing;
  writeNotNull('VideoType', _$VideoTypeEnumMap[instance.videoType]);
  writeNotNull('IsoType', _$IsoTypeEnumMap[instance.isoType]);
  writeNotNull('Video3DFormat', _$Video3DFormatEnumMap[instance.video3DFormat]);
  val['MediaStreams'] = instance.mediaStreams;
  val['MediaAttachments'] = instance.mediaAttachments;
  val['Formats'] = instance.formats;
  writeNotNull('Bitrate', instance.bitrate);
  writeNotNull('Timestamp', _$TimestampEnumMap[instance.timestamp]);
  val['RequiredHttpHeaders'] = instance.requiredHttpHeaders;
  writeNotNull('TranscodingUrl', instance.transcodingUrl);
  writeNotNull('TranscodingSubProtocol', instance.transcodingSubProtocol);
  writeNotNull('TranscodingContainer', instance.transcodingContainer);
  writeNotNull('AnalyzeDurationMs', instance.analyzeDurationMs);
  writeNotNull('DefaultAudioStreamIndex', instance.defaultAudioStreamIndex);
  writeNotNull(
      'DefaultSubtitleStreamIndex', instance.defaultSubtitleStreamIndex);
  return val;
}

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
