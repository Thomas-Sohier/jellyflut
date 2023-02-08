import 'dart:convert';

import 'device_profile.dart';

DeviceProfileParent deviceCodecsFromMap(String str) => DeviceProfileParent.fromMap(json.decode(str));

String deviceCodecsToMap(DeviceProfileParent data) => json.encode(data.toMap());

class DeviceProfileParent {
  String? userId;
  int? maxStreamingBitrate;
  int? startTimeTicks;
  int? audioStreamIndex;
  int? subtitleStreamIndex;
  int? maxAudioChannels;
  String? mediaSourceId;
  String? liveStreamId;
  DeviceProfile? deviceProfile;
  bool? enableDirectPlay;
  bool? enableDirectStream;
  bool? enableTranscoding;
  bool? allowVideoStreamCopy;
  bool? allowAudioStreamCopy;
  bool? autoOpenLiveStream;

  DeviceProfileParent(
      {this.userId,
      this.maxStreamingBitrate,
      this.startTimeTicks,
      this.audioStreamIndex,
      this.subtitleStreamIndex,
      this.maxAudioChannels,
      this.mediaSourceId,
      this.liveStreamId,
      this.deviceProfile,
      this.enableDirectPlay,
      this.enableDirectStream,
      this.enableTranscoding,
      this.allowVideoStreamCopy,
      this.allowAudioStreamCopy,
      this.autoOpenLiveStream});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'maxStreamingBitrate': maxStreamingBitrate,
      'startTimeTicks': startTimeTicks,
      'audioStreamIndex': audioStreamIndex,
      'subtitleStreamIndex': subtitleStreamIndex,
      'maxAudioChannels': maxAudioChannels,
      'mediaSourceId': mediaSourceId,
      'liveStreamId': liveStreamId,
      'deviceProfile': deviceProfile?.toMap(),
      'enableDirectPlay': enableDirectPlay,
      'enableDirectStream': enableDirectStream,
      'enableTranscoding': enableTranscoding,
      'allowVideoStreamCopy': allowVideoStreamCopy,
      'allowAudioStreamCopy': allowAudioStreamCopy,
      'autoOpenLiveStream': autoOpenLiveStream,
    }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
  }

  DeviceProfileParent copyWith({
    String? userId,
    int? maxStreamingBitrate,
    int? startTimeTicks,
    int? audioStreamIndex,
    int? subtitleStreamIndex,
    int? maxAudioChannels,
    String? mediaSourceId,
    String? liveStreamId,
    DeviceProfile? deviceProfile,
    bool? enableDirectPlay,
    bool? enableDirectStream,
    bool? enableTranscoding,
    bool? allowVideoStreamCopy,
    bool? allowAudioStreamCopy,
    bool? autoOpenLiveStream,
  }) {
    return DeviceProfileParent(
      userId: userId ?? this.userId,
      maxStreamingBitrate: maxStreamingBitrate ?? this.maxStreamingBitrate,
      startTimeTicks: startTimeTicks ?? this.startTimeTicks,
      audioStreamIndex: audioStreamIndex ?? this.audioStreamIndex,
      subtitleStreamIndex: subtitleStreamIndex ?? this.subtitleStreamIndex,
      maxAudioChannels: maxAudioChannels ?? this.maxAudioChannels,
      mediaSourceId: mediaSourceId ?? this.mediaSourceId,
      liveStreamId: liveStreamId ?? this.liveStreamId,
      deviceProfile: deviceProfile ?? this.deviceProfile,
      enableDirectPlay: enableDirectPlay ?? this.enableDirectPlay,
      enableDirectStream: enableDirectStream ?? this.enableDirectStream,
      enableTranscoding: enableTranscoding ?? this.enableTranscoding,
      allowVideoStreamCopy: allowVideoStreamCopy ?? this.allowVideoStreamCopy,
      allowAudioStreamCopy: allowAudioStreamCopy ?? this.allowAudioStreamCopy,
      autoOpenLiveStream: autoOpenLiveStream ?? this.autoOpenLiveStream,
    );
  }

  factory DeviceProfileParent.fromMap(Map<String, dynamic> map) {
    return DeviceProfileParent(
      userId: map['userId']?.toInt(),
      maxStreamingBitrate: map['maxStreamingBitrate']?.toInt(),
      startTimeTicks: map['startTimeTicks']?.toInt(),
      audioStreamIndex: map['audioStreamIndex']?.toInt(),
      subtitleStreamIndex: map['subtitleStreamIndex']?.toInt(),
      maxAudioChannels: map['maxAudioChannels']?.toInt(),
      mediaSourceId: map['mediaSourceId'],
      liveStreamId: map['liveStreamId'],
      deviceProfile: map['deviceProfile'] != null ? DeviceProfile.fromMap(map['deviceProfile']) : null,
      enableDirectPlay: map['enableDirectPlay'],
      enableDirectStream: map['enableDirectStream'],
      enableTranscoding: map['enableTranscoding'],
      allowVideoStreamCopy: map['allowVideoStreamCopy'],
      allowAudioStreamCopy: map['allowAudioStreamCopy'],
      autoOpenLiveStream: map['autoOpenLiveStream'],
    );
  }
  String toJson() => json.encode(toMap());

  factory DeviceProfileParent.fromJson(String source) => DeviceProfileParent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeviceProfileParent(userId: $userId, maxStreamingBitrate: $maxStreamingBitrate, startTimeTicks: $startTimeTicks, audioStreamIndex: $audioStreamIndex, subtitleStreamIndex: $subtitleStreamIndex, maxAudioChannels: $maxAudioChannels, mediaSourceId: $mediaSourceId, liveStreamId: $liveStreamId, deviceProfile: $deviceProfile, enableDirectPlay: $enableDirectPlay, enableDirectStream: $enableDirectStream, enableTranscoding: $enableTranscoding, allowVideoStreamCopy: $allowVideoStreamCopy, allowAudioStreamCopy: $allowAudioStreamCopy, autoOpenLiveStream: $autoOpenLiveStream)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceProfileParent &&
        other.userId == userId &&
        other.maxStreamingBitrate == maxStreamingBitrate &&
        other.startTimeTicks == startTimeTicks &&
        other.audioStreamIndex == audioStreamIndex &&
        other.subtitleStreamIndex == subtitleStreamIndex &&
        other.maxAudioChannels == maxAudioChannels &&
        other.mediaSourceId == mediaSourceId &&
        other.liveStreamId == liveStreamId &&
        other.deviceProfile == deviceProfile &&
        other.enableDirectPlay == enableDirectPlay &&
        other.enableDirectStream == enableDirectStream &&
        other.enableTranscoding == enableTranscoding &&
        other.allowVideoStreamCopy == allowVideoStreamCopy &&
        other.allowAudioStreamCopy == allowAudioStreamCopy &&
        other.autoOpenLiveStream == autoOpenLiveStream;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        maxStreamingBitrate.hashCode ^
        startTimeTicks.hashCode ^
        audioStreamIndex.hashCode ^
        subtitleStreamIndex.hashCode ^
        maxAudioChannels.hashCode ^
        mediaSourceId.hashCode ^
        liveStreamId.hashCode ^
        deviceProfile.hashCode ^
        enableDirectPlay.hashCode ^
        enableDirectStream.hashCode ^
        enableTranscoding.hashCode ^
        allowVideoStreamCopy.hashCode ^
        allowAudioStreamCopy.hashCode ^
        autoOpenLiveStream.hashCode;
  }
}
