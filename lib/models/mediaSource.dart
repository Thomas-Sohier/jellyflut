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
    this.defaultAudioStreamIndex,
    this.defaultSubtitleStreamIndex,
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
  int defaultAudioStreamIndex;
  int defaultSubtitleStreamIndex;

  factory MediaSource.fromMap(Map<String, dynamic> json) => MediaSource(
        protocol: json["Protocol"],
        id: json["Id"],
        path: json["Path"],
        type: json["Type"],
        container: json["Container"],
        size: json["Size"],
        name: json["Name"],
        isRemote: json["IsRemote"],
        eTag: json["ETag"],
        runTimeTicks: json["RunTimeTicks"],
        readAtNativeFramerate: json["ReadAtNativeFramerate"],
        ignoreDts: json["IgnoreDts"],
        ignoreIndex: json["IgnoreIndex"],
        genPtsInput: json["GenPtsInput"],
        supportsTranscoding: json["SupportsTranscoding"],
        supportsDirectStream: json["SupportsDirectStream"],
        supportsDirectPlay: json["SupportsDirectPlay"],
        isInfiniteStream: json["IsInfiniteStream"],
        requiresOpening: json["RequiresOpening"],
        requiresClosing: json["RequiresClosing"],
        requiresLooping: json["RequiresLooping"],
        supportsProbing: json["SupportsProbing"],
        videoType: json["VideoType"],
        mediaStreams: List<MediaStream>.from(
            json["MediaStreams"].map((x) => MediaStream.fromMap(x))),
        mediaAttachments:
            List<dynamic>.from(json["MediaAttachments"].map((x) => x)),
        formats: List<dynamic>.from(json["Formats"].map((x) => x)),
        bitrate: json["Bitrate"],
        requiredHttpHeaders:
            RequiredHttpHeaders.fromMap(json["RequiredHttpHeaders"]),
        defaultAudioStreamIndex: json["DefaultAudioStreamIndex"],
        defaultSubtitleStreamIndex: json["DefaultSubtitleStreamIndex"],
      );

  Map<String, dynamic> toMap() => {
        "Protocol": protocol,
        "Id": id,
        "Path": path,
        "Type": type,
        "Container": container,
        "Size": size,
        "Name": name,
        "IsRemote": isRemote,
        "ETag": eTag,
        "RunTimeTicks": runTimeTicks,
        "ReadAtNativeFramerate": readAtNativeFramerate,
        "IgnoreDts": ignoreDts,
        "IgnoreIndex": ignoreIndex,
        "GenPtsInput": genPtsInput,
        "SupportsTranscoding": supportsTranscoding,
        "SupportsDirectStream": supportsDirectStream,
        "SupportsDirectPlay": supportsDirectPlay,
        "IsInfiniteStream": isInfiniteStream,
        "RequiresOpening": requiresOpening,
        "RequiresClosing": requiresClosing,
        "RequiresLooping": requiresLooping,
        "SupportsProbing": supportsProbing,
        "VideoType": videoType,
        "MediaStreams": List<dynamic>.from(mediaStreams.map((x) => x.toMap())),
        "MediaAttachments": List<dynamic>.from(mediaAttachments.map((x) => x)),
        "Formats": List<dynamic>.from(formats.map((x) => x)),
        "Bitrate": bitrate,
        "RequiredHttpHeaders": requiredHttpHeaders.toMap(),
        "DefaultAudioStreamIndex": defaultAudioStreamIndex,
        "DefaultSubtitleStreamIndex": defaultSubtitleStreamIndex,
      };
}
