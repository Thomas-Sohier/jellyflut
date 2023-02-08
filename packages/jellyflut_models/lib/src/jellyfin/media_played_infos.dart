// To parse this JSON data, do
//
//     final mediaPlayedInfos = mediaPlayedInfosFromJson(jsonString);

import 'dart:convert';

import 'buffered_range.dart';

MediaPlayedInfos mediaPlayedInfosFromJson(String str) => MediaPlayedInfos.fromJson(json.decode(str));

String mediaPlayedInfosToJson(MediaPlayedInfos data) => json.encode(data.toJson());

class MediaPlayedInfos {
  MediaPlayedInfos({
    this.volumeLevel,
    this.isMuted,
    this.isPaused,
    this.repeatMode,
    this.shuffleMode,
    this.maxStreamingBitrate,
    this.positionTicks,
    this.playbackStartTimeTicks,
    this.subtitleStreamIndex,
    this.audioStreamIndex,
    this.bufferedRanges,
    this.playMethod,
    this.playSessionId,
    this.playlistItemId,
    this.mediaSourceId,
    this.canSeek,
    this.itemId,
    this.eventName,
  });

  int? volumeLevel;
  bool? isMuted;
  bool? isPaused;
  String? repeatMode;
  String? shuffleMode;
  int? maxStreamingBitrate;
  int? positionTicks;
  double? playbackStartTimeTicks;
  int? subtitleStreamIndex;
  int? audioStreamIndex;
  List<BufferedRange>? bufferedRanges;
  String? playMethod;
  String? playSessionId;
  String? playlistItemId;
  String? mediaSourceId;
  bool? canSeek;
  String? itemId;
  String? eventName;

  factory MediaPlayedInfos.fromJson(Map<String, dynamic> json) => MediaPlayedInfos(
        volumeLevel: json['VolumeLevel'],
        isMuted: json['IsMuted'],
        isPaused: json['IsPaused'],
        repeatMode: json['RepeatMode'],
        shuffleMode: json['ShuffleMode'],
        maxStreamingBitrate: json['MaxStreamingBitrate'],
        positionTicks: json['PositionTicks'],
        playbackStartTimeTicks: json['PlaybackStartTimeTicks']?.toDouble(),
        subtitleStreamIndex: json['SubtitleStreamIndex'],
        audioStreamIndex: json['AudioStreamIndex'],
        bufferedRanges: json['BufferedRanges'] == null
            ? null
            : List<BufferedRange>.from(json['BufferedRanges'].map((x) => BufferedRange.fromJson(x))),
        playMethod: json['PlayMethod'],
        playSessionId: json['PlaySessionId'],
        playlistItemId: json['PlaylistItemId'],
        mediaSourceId: json['MediaSourceId'],
        canSeek: json['CanSeek'],
        itemId: json['ItemId'],
        eventName: json['EventName'],
      );

  Map<String, dynamic> toJson() => {
        'VolumeLevel': volumeLevel,
        'IsMuted': isMuted,
        'IsPaused': isPaused,
        'RepeatMode': repeatMode,
        'ShuffleMode': shuffleMode,
        'MaxStreamingBitrate': maxStreamingBitrate,
        'PositionTicks': positionTicks,
        'PlaybackStartTimeTicks': playbackStartTimeTicks,
        'SubtitleStreamIndex': subtitleStreamIndex,
        'AudioStreamIndex': audioStreamIndex,
        'BufferedRanges': bufferedRanges == null ? null : List<dynamic>.from(bufferedRanges!.map((x) => x.toJson())),
        'PlayMethod': playMethod,
        'PlaySessionId': playSessionId,
        'PlaylistItemId': playlistItemId,
        'MediaSourceId': mediaSourceId,
        'CanSeek': canSeek,
        'ItemId': itemId,
        'EventName': eventName,
      };
}
