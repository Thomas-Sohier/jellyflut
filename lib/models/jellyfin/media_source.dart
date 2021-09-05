import 'package:jellyflut/models/jellyfin/required_http_headers.dart';

import 'media_stream.dart';

class MediaSource {
  MediaSource({
    this.protocol,
    this.id,
    this.path,
    this.type,
    this.container,
    this.size,
    this.name,
    this.isRemote,
    this.eTag,
    this.runTimeTicks,
    this.readAtNativeFramerate,
    this.ignoreDts,
    this.ignoreIndex,
    this.genPtsInput,
    this.supportsTranscoding,
    this.supportsDirectStream,
    this.supportsDirectPlay,
    this.isInfiniteStream,
    this.requiresOpening,
    this.requiresClosing,
    this.requiresLooping,
    this.supportsProbing,
    this.videoType,
    this.mediaStreams,
    this.mediaAttachments,
    this.formats,
    this.bitrate,
    this.requiredHttpHeaders,
    this.transcodingUrl,
    this.transcodingSubProtocol,
    this.transcodingContainer,
    this.defaultAudioStreamIndex,
  });

  String? protocol;
  String? id;
  String? path;
  String? type;
  String? container;
  int? size;
  String? name;
  bool? isRemote;
  String? eTag;
  int? runTimeTicks;
  bool? readAtNativeFramerate;
  bool? ignoreDts;
  bool? ignoreIndex;
  bool? genPtsInput;
  bool? supportsTranscoding;
  bool? supportsDirectStream;
  bool? supportsDirectPlay;
  bool? isInfiniteStream;
  bool? requiresOpening;
  bool? requiresClosing;
  bool? requiresLooping;
  bool? supportsProbing;
  String? videoType;
  List<MediaStream>? mediaStreams;
  List<dynamic>? mediaAttachments;
  List<dynamic>? formats;
  int? bitrate;
  RequiredHttpHeaders? requiredHttpHeaders;
  String? transcodingUrl;
  String? transcodingSubProtocol;
  String? transcodingContainer;
  int? defaultAudioStreamIndex;

  factory MediaSource.fromMap(Map<String, dynamic> json) => MediaSource(
        protocol: json['Protocol'],
        id: json['Id'],
        path: json['Path'],
        type: json['Type'],
        container: json['Container'],
        size: json['Size'],
        name: json['Name'],
        isRemote: json['IsRemote'],
        eTag: json['ETag'],
        runTimeTicks: json['RunTimeTicks'],
        readAtNativeFramerate: json['ReadAtNativeFramerate'],
        ignoreDts: json['IgnoreDts'],
        ignoreIndex: json['IgnoreIndex'],
        genPtsInput: json['GenPtsInput'],
        supportsTranscoding: json['SupportsTranscoding'],
        supportsDirectStream: json['SupportsDirectStream'],
        supportsDirectPlay: json['SupportsDirectPlay'],
        isInfiniteStream: json['IsInfiniteStream'],
        requiresOpening: json['RequiresOpening'],
        requiresClosing: json['RequiresClosing'],
        requiresLooping: json['RequiresLooping'],
        supportsProbing: json['SupportsProbing'],
        videoType: json['VideoType'],
        mediaStreams: json['MediaStreams'] == null
            ? null
            : List<MediaStream>.from(
                json['MediaStreams'].map((x) => MediaStream.fromMap(x))),
        mediaAttachments: json['MediaAttachments'] == null
            ? null
            : List<dynamic>.from(json['MediaAttachments'].map((x) => x)),
        formats: json['Formats'] == null
            ? null
            : List<dynamic>.from(json['Formats'].map((x) => x)),
        bitrate: json['Bitrate'],
        requiredHttpHeaders: json['RequiredHttpHeaders'] == null
            ? null
            : RequiredHttpHeaders.fromMap(json['RequiredHttpHeaders']),
        transcodingUrl: json['TranscodingUrl'],
        transcodingSubProtocol: json['TranscodingSubProtocol'],
        transcodingContainer: json['TranscodingContainer'],
        defaultAudioStreamIndex: json['DefaultAudioStreamIndex'],
      );

  Map<String, dynamic> toMap() => {
        'Protocol': protocol,
        'Id': id,
        'Path': path,
        'Type': type,
        'Container': container,
        'Size': size,
        'Name': name,
        'IsRemote': isRemote,
        'ETag': eTag,
        'RunTimeTicks': runTimeTicks,
        'ReadAtNativeFramerate': readAtNativeFramerate,
        'IgnoreDts': ignoreDts,
        'IgnoreIndex': ignoreIndex,
        'GenPtsInput': genPtsInput,
        'SupportsTranscoding': supportsTranscoding,
        'SupportsDirectStream': supportsDirectStream,
        'SupportsDirectPlay': supportsDirectPlay,
        'IsInfiniteStream': isInfiniteStream,
        'RequiresOpening': requiresOpening,
        'RequiresClosing': requiresClosing,
        'RequiresLooping': requiresLooping,
        'SupportsProbing': supportsProbing,
        'VideoType': videoType,
        'MediaStreams': mediaStreams == null
            ? null
            : List<dynamic>.from(mediaStreams!.map((x) => x.toMap())),
        'MediaAttachments': mediaAttachments == null
            ? null
            : List<dynamic>.from(mediaAttachments!.map((x) => x)),
        'Formats':
            formats == null ? null : List<dynamic>.from(formats!.map((x) => x)),
        'Bitrate': bitrate,
        'RequiredHttpHeaders':
            requiredHttpHeaders == null ? null : requiredHttpHeaders!.toMap(),
        'TranscodingUrl': transcodingUrl,
        'TranscodingSubProtocol': transcodingSubProtocol,
        'TranscodingContainer': transcodingContainer,
        'DefaultAudioStreamIndex': defaultAudioStreamIndex,
      };
}
