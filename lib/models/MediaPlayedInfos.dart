// To parse this JSON data, do
//
//     final mediaPlayedInfos = mediaPlayedInfosFromJson(jsonString);

import 'dart:convert';

import 'BufferedRange.dart';

MediaPlayedInfos mediaPlayedInfosFromJson(String str) =>
    MediaPlayedInfos.fromJson(json.decode(str));

String mediaPlayedInfosToJson(MediaPlayedInfos data) =>
    json.encode(data.toJson());

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

  int volumeLevel;
  bool isMuted;
  bool isPaused;
  String repeatMode;
  String shuffleMode;
  int maxStreamingBitrate;
  int positionTicks;
  double playbackStartTimeTicks;
  int subtitleStreamIndex;
  int audioStreamIndex;
  List<BufferedRange> bufferedRanges;
  String playMethod;
  String playSessionId;
  String playlistItemId;
  String mediaSourceId;
  bool canSeek;
  String itemId;
  String eventName;

  factory MediaPlayedInfos.fromJson(Map<String, dynamic> json) =>
      MediaPlayedInfos(
        volumeLevel: json["VolumeLevel"] == null ? null : json["VolumeLevel"],
        isMuted: json["IsMuted"] == null ? null : json["IsMuted"],
        isPaused: json["IsPaused"] == null ? null : json["IsPaused"],
        repeatMode: json["RepeatMode"] == null ? null : json["RepeatMode"],
        shuffleMode: json["ShuffleMode"] == null ? null : json["ShuffleMode"],
        maxStreamingBitrate: json["MaxStreamingBitrate"] == null
            ? null
            : json["MaxStreamingBitrate"],
        positionTicks:
            json["PositionTicks"] == null ? null : json["PositionTicks"],
        playbackStartTimeTicks: json["PlaybackStartTimeTicks"] == null
            ? null
            : json["PlaybackStartTimeTicks"].toDouble(),
        subtitleStreamIndex: json["SubtitleStreamIndex"] == null
            ? null
            : json["SubtitleStreamIndex"],
        audioStreamIndex:
            json["AudioStreamIndex"] == null ? null : json["AudioStreamIndex"],
        bufferedRanges: json["BufferedRanges"] == null
            ? null
            : List<BufferedRange>.from(
                json["BufferedRanges"].map((x) => BufferedRange.fromJson(x))),
        playMethod: json["PlayMethod"] == null ? null : json["PlayMethod"],
        playSessionId:
            json["PlaySessionId"] == null ? null : json["PlaySessionId"],
        playlistItemId:
            json["PlaylistItemId"] == null ? null : json["PlaylistItemId"],
        mediaSourceId:
            json["MediaSourceId"] == null ? null : json["MediaSourceId"],
        canSeek: json["CanSeek"] == null ? null : json["CanSeek"],
        itemId: json["ItemId"] == null ? null : json["ItemId"],
        eventName: json["EventName"] == null ? null : json["EventName"],
      );

  Map<String, dynamic> toJson() => {
        "VolumeLevel": volumeLevel == null ? null : volumeLevel,
        "IsMuted": isMuted == null ? null : isMuted,
        "IsPaused": isPaused == null ? null : isPaused,
        "RepeatMode": repeatMode == null ? null : repeatMode,
        "ShuffleMode": shuffleMode == null ? null : shuffleMode,
        "MaxStreamingBitrate":
            maxStreamingBitrate == null ? null : maxStreamingBitrate,
        "PositionTicks": positionTicks == null ? null : positionTicks,
        "PlaybackStartTimeTicks":
            playbackStartTimeTicks == null ? null : playbackStartTimeTicks,
        "SubtitleStreamIndex":
            subtitleStreamIndex == null ? null : subtitleStreamIndex,
        "AudioStreamIndex": audioStreamIndex == null ? null : audioStreamIndex,
        "BufferedRanges": bufferedRanges == null
            ? null
            : List<dynamic>.from(bufferedRanges.map((x) => x.toJson())),
        "PlayMethod": playMethod == null ? null : playMethod,
        "PlaySessionId": playSessionId == null ? null : playSessionId,
        "PlaylistItemId": playlistItemId == null ? null : playlistItemId,
        "MediaSourceId": mediaSourceId == null ? null : mediaSourceId,
        "CanSeek": canSeek == null ? null : canSeek,
        "ItemId": itemId == null ? null : itemId,
        "EventName": eventName == null ? null : eventName,
      };
}
