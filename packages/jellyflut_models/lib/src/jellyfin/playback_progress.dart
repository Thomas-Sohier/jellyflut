import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../enum/index.dart';
import 'index.dart';

class PlaybackProgress {
  final bool canSeek;
  final Item? item;
  final String itemId;
  final String? sessionId;
  final String? mediaSourceId;
  final int? audioStreamIndex;
  final int? subtitleStreamIndex;
  final bool isPaused;
  final bool isMuted;
  final int? positionTicks;
  final int? playbackStartTimeTicks;
  final int? volumeLevel;
  final int? brightness;
  final String? aspectRatio;
  final PlayMethod playMethod;
  final String? liveStreamId;
  final String? playSessionId;
  final RepeatMode repeatMode;
  final List<NowPlayingQueue> nowPlayingQueue;
  final String? playlistItemId;
  PlaybackProgress({
    required this.canSeek,
    this.item,
    required this.itemId,
    this.sessionId,
    this.mediaSourceId,
    this.audioStreamIndex,
    this.subtitleStreamIndex,
    required this.isPaused,
    required this.isMuted,
    this.positionTicks,
    this.playbackStartTimeTicks,
    this.volumeLevel,
    this.brightness,
    this.aspectRatio,
    required this.playMethod,
    this.liveStreamId,
    this.playSessionId,
    required this.repeatMode,
    required this.nowPlayingQueue,
    this.playlistItemId,
  });

  PlaybackProgress copyWith({
    bool? canSeek,
    Item? item,
    String? itemId,
    String? sessionId,
    String? mediaSourceId,
    int? audioStreamIndex,
    int? subtitleStreamIndex,
    bool? isPaused,
    bool? isMuted,
    int? positionTicks,
    int? playbackStartTimeTicks,
    int? volumeLevel,
    int? brightness,
    String? aspectRatio,
    PlayMethod? playMethod,
    String? liveStreamId,
    String? playSessionId,
    RepeatMode? repeatMode,
    List<NowPlayingQueue>? nowPlayingQueue,
    String? playlistItemId,
  }) {
    return PlaybackProgress(
      canSeek: canSeek ?? this.canSeek,
      item: item ?? this.item,
      itemId: itemId ?? this.itemId,
      sessionId: sessionId ?? this.sessionId,
      mediaSourceId: mediaSourceId ?? this.mediaSourceId,
      audioStreamIndex: audioStreamIndex ?? this.audioStreamIndex,
      subtitleStreamIndex: subtitleStreamIndex ?? this.subtitleStreamIndex,
      isPaused: isPaused ?? this.isPaused,
      isMuted: isMuted ?? this.isMuted,
      positionTicks: positionTicks ?? this.positionTicks,
      playbackStartTimeTicks: playbackStartTimeTicks ?? this.playbackStartTimeTicks,
      volumeLevel: volumeLevel ?? this.volumeLevel,
      brightness: brightness ?? this.brightness,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      playMethod: playMethod ?? this.playMethod,
      liveStreamId: liveStreamId ?? this.liveStreamId,
      playSessionId: playSessionId ?? this.playSessionId,
      repeatMode: repeatMode ?? this.repeatMode,
      nowPlayingQueue: nowPlayingQueue ?? this.nowPlayingQueue,
      playlistItemId: playlistItemId ?? this.playlistItemId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CanSeek': canSeek,
      'Item': item?.toJson(),
      'ItemId': itemId,
      'SessionId': sessionId,
      'MediaSourceId': mediaSourceId,
      'AudioStreamIndex': audioStreamIndex,
      'SubtitleStreamIndex': subtitleStreamIndex,
      'IsPaused': isPaused,
      'IsMuted': isMuted,
      'PositionTicks': positionTicks,
      'PlaybackStartTimeTicks': playbackStartTimeTicks,
      'VolumeLevel': volumeLevel,
      'Brightness': brightness,
      'AspectRatio': aspectRatio,
      'PlayMethod': playMethod.value,
      'LiveStreamId': liveStreamId,
      'PlaySessionId': playSessionId,
      'RepeatMode': repeatMode.value,
      'NowPlayingQueue': nowPlayingQueue.map((x) => x.toMap()).toList(),
      'PlaylistItemId': playlistItemId,
    };
  }

  factory PlaybackProgress.fromMap(Map<String, dynamic> map) {
    return PlaybackProgress(
      canSeek: map['CanSeek'] ?? false,
      item: Item.fromJson(map['Item']),
      itemId: map['ItemId'] ?? '',
      sessionId: map['SessionId'] ?? '',
      mediaSourceId: map['MediaSourceId'] ?? '',
      audioStreamIndex: map['AudioStreamIndex']?.toInt() ?? 0,
      subtitleStreamIndex: map['SubtitleStreamIndex']?.toInt() ?? 0,
      isPaused: map['IsPaused'] ?? false,
      isMuted: map['IsMuted'] ?? false,
      positionTicks: map['PositionTicks']?.toInt() ?? 0,
      playbackStartTimeTicks: map['PlaybackStartTimeTicks']?.toInt() ?? 0,
      volumeLevel: map['VolumeLevel']?.toInt() ?? 0,
      brightness: map['Brightness']?.toInt() ?? 0,
      aspectRatio: map['AspectRatio'] ?? '',
      playMethod: PlayMethod.fromString(map['PlayMethod']),
      liveStreamId: map['LiveStreamId'] ?? '',
      playSessionId: map['PlaySessionId'] ?? '',
      repeatMode: RepeatMode.fromString(map['RepeatMode']),
      nowPlayingQueue: List<NowPlayingQueue>.from(map['NowPlayingQueue']?.map((x) => NowPlayingQueue.fromMap(x))),
      playlistItemId: map['PlaylistItemId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaybackProgress.fromJson(String source) => PlaybackProgress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaybackProgress(CanSeek: $canSeek, Item: $item, ItemId: $itemId, SessionId: $sessionId, MediaSourceId: $mediaSourceId, AudioStreamIndex: $audioStreamIndex, SubtitleStreamIndex: $subtitleStreamIndex, IsPaused: $isPaused, IsMuted: $isMuted, PositionTicks: $positionTicks, PlaybackStartTimeTicks: $playbackStartTimeTicks, VolumeLevel: $volumeLevel, Brightness: $brightness, AspectRatio: $aspectRatio, PlayMethod: $playMethod, LiveStreamId: $liveStreamId, PlaySessionId: $playSessionId, RepeatMode: $repeatMode, NowPlayingQueue: $nowPlayingQueue, PlaylistItemId: $playlistItemId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaybackProgress &&
        other.canSeek == canSeek &&
        other.item == item &&
        other.itemId == itemId &&
        other.sessionId == sessionId &&
        other.mediaSourceId == mediaSourceId &&
        other.audioStreamIndex == audioStreamIndex &&
        other.subtitleStreamIndex == subtitleStreamIndex &&
        other.isPaused == isPaused &&
        other.isMuted == isMuted &&
        other.positionTicks == positionTicks &&
        other.playbackStartTimeTicks == playbackStartTimeTicks &&
        other.volumeLevel == volumeLevel &&
        other.brightness == brightness &&
        other.aspectRatio == aspectRatio &&
        other.playMethod == playMethod &&
        other.liveStreamId == liveStreamId &&
        other.playSessionId == playSessionId &&
        other.repeatMode == repeatMode &&
        listEquals(other.nowPlayingQueue, nowPlayingQueue) &&
        other.playlistItemId == playlistItemId;
  }

  @override
  int get hashCode {
    return canSeek.hashCode ^
        item.hashCode ^
        itemId.hashCode ^
        sessionId.hashCode ^
        mediaSourceId.hashCode ^
        audioStreamIndex.hashCode ^
        subtitleStreamIndex.hashCode ^
        isPaused.hashCode ^
        isMuted.hashCode ^
        positionTicks.hashCode ^
        playbackStartTimeTicks.hashCode ^
        volumeLevel.hashCode ^
        brightness.hashCode ^
        aspectRatio.hashCode ^
        playMethod.hashCode ^
        liveStreamId.hashCode ^
        playSessionId.hashCode ^
        repeatMode.hashCode ^
        nowPlayingQueue.hashCode ^
        playlistItemId.hashCode;
  }
}
