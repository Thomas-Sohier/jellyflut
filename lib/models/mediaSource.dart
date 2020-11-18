import 'package:jellyflut/shared/enums.dart';

import 'mediaStream.dart';

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

  String protocol;
  String id;
  String path;
  String type;
  String container;
  int size;
  String name;
  bool isRemote;
  String eTag;
  int runTimeTicks;
  bool readAtNativeFramerate;
  bool ignoreDts;
  bool ignoreIndex;
  bool genPtsInput;
  bool supportsTranscoding;
  bool supportsDirectStream;
  bool supportsDirectPlay;
  bool isInfiniteStream;
  bool requiresOpening;
  bool requiresClosing;
  bool requiresLooping;
  bool supportsProbing;
  String videoType;
  List<MediaStream> mediaStreams;
  List<dynamic> mediaAttachments;
  List<dynamic> formats;
  int bitrate;
  RequiredHttpHeaders requiredHttpHeaders;
  String transcodingUrl;
  String transcodingSubProtocol;
  String transcodingContainer;
  int defaultAudioStreamIndex;

  factory MediaSource.fromMap(Map<String, dynamic> json) => MediaSource(
        protocol: json['Protocol'] == null ? null : json['Protocol'],
        id: json['Id'] == null ? null : json['Id'],
        path: json['Path'] == null ? null : json['Path'],
        type: json['Type'] == null ? null : json['Type'],
        container: json['Container'] == null ? null : json['Container'],
        size: json['Size'] == null ? null : json['Size'],
        name: json['Name'] == null ? null : json['Name'],
        isRemote: json['IsRemote'] == null ? null : json['IsRemote'],
        eTag: json['ETag'] == null ? null : json['ETag'],
        runTimeTicks:
            json['RunTimeTicks'] == null ? null : json['RunTimeTicks'],
        readAtNativeFramerate: json['ReadAtNativeFramerate'] == null
            ? null
            : json['ReadAtNativeFramerate'],
        ignoreDts: json['IgnoreDts'] == null ? null : json['IgnoreDts'],
        ignoreIndex: json['IgnoreIndex'] == null ? null : json['IgnoreIndex'],
        genPtsInput: json['GenPtsInput'] == null ? null : json['GenPtsInput'],
        supportsTranscoding: json['SupportsTranscoding'] == null
            ? null
            : json['SupportsTranscoding'],
        supportsDirectStream: json['SupportsDirectStream'] == null
            ? null
            : json['SupportsDirectStream'],
        supportsDirectPlay: json['SupportsDirectPlay'] == null
            ? null
            : json['SupportsDirectPlay'],
        isInfiniteStream:
            json['IsInfiniteStream'] == null ? null : json['IsInfiniteStream'],
        requiresOpening:
            json['RequiresOpening'] == null ? null : json['RequiresOpening'],
        requiresClosing:
            json['RequiresClosing'] == null ? null : json['RequiresClosing'],
        requiresLooping:
            json['RequiresLooping'] == null ? null : json['RequiresLooping'],
        supportsProbing:
            json['SupportsProbing'] == null ? null : json['SupportsProbing'],
        videoType: json['VideoType'] == null ? null : json['VideoType'],
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
        bitrate: json['Bitrate'] == null ? null : json['Bitrate'],
        requiredHttpHeaders: json['RequiredHttpHeaders'] == null
            ? null
            : RequiredHttpHeaders.fromMap(json['RequiredHttpHeaders']),
        transcodingUrl:
            json['TranscodingUrl'] == null ? null : json['TranscodingUrl'],
        transcodingSubProtocol: json['TranscodingSubProtocol'] == null
            ? null
            : json['TranscodingSubProtocol'],
        transcodingContainer: json['TranscodingContainer'] == null
            ? null
            : json['TranscodingContainer'],
        defaultAudioStreamIndex: json['DefaultAudioStreamIndex'] == null
            ? null
            : json['DefaultAudioStreamIndex'],
      );

  Map<String, dynamic> toMap() => {
        'Protocol': protocol == null ? null : protocol,
        'Id': id == null ? null : id,
        'Path': path == null ? null : path,
        'Type': type == null ? null : type,
        'Container': container == null ? null : container,
        'Size': size == null ? null : size,
        'Name': name == null ? null : name,
        'IsRemote': isRemote == null ? null : isRemote,
        'ETag': eTag == null ? null : eTag,
        'RunTimeTicks': runTimeTicks == null ? null : runTimeTicks,
        'ReadAtNativeFramerate':
            readAtNativeFramerate == null ? null : readAtNativeFramerate,
        'IgnoreDts': ignoreDts == null ? null : ignoreDts,
        'IgnoreIndex': ignoreIndex == null ? null : ignoreIndex,
        'GenPtsInput': genPtsInput == null ? null : genPtsInput,
        'SupportsTranscoding':
            supportsTranscoding == null ? null : supportsTranscoding,
        'SupportsDirectStream':
            supportsDirectStream == null ? null : supportsDirectStream,
        'SupportsDirectPlay':
            supportsDirectPlay == null ? null : supportsDirectPlay,
        'IsInfiniteStream': isInfiniteStream == null ? null : isInfiniteStream,
        'RequiresOpening': requiresOpening == null ? null : requiresOpening,
        'RequiresClosing': requiresClosing == null ? null : requiresClosing,
        'RequiresLooping': requiresLooping == null ? null : requiresLooping,
        'SupportsProbing': supportsProbing == null ? null : supportsProbing,
        'VideoType': videoType == null ? null : videoType,
        'MediaStreams': mediaStreams == null
            ? null
            : List<dynamic>.from(mediaStreams.map((x) => x.toMap())),
        'MediaAttachments': mediaAttachments == null
            ? null
            : List<dynamic>.from(mediaAttachments.map((x) => x)),
        'Formats':
            formats == null ? null : List<dynamic>.from(formats.map((x) => x)),
        'Bitrate': bitrate == null ? null : bitrate,
        'RequiredHttpHeaders':
            requiredHttpHeaders == null ? null : requiredHttpHeaders.toMap(),
        'TranscodingUrl': transcodingUrl == null ? null : transcodingUrl,
        'TranscodingSubProtocol':
            transcodingSubProtocol == null ? null : transcodingSubProtocol,
        'TranscodingContainer':
            transcodingContainer == null ? null : transcodingContainer,
        'DefaultAudioStreamIndex':
            defaultAudioStreamIndex == null ? null : defaultAudioStreamIndex,
      };
}
