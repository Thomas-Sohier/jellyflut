import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/jellyfin/codec_profile.dart';
import 'package:jellyflut/models/jellyfin/condition.dart';
import 'package:jellyflut/models/jellyfin/device_codecs.dart';
import 'package:jellyflut/models/jellyfin/device_profile.dart';
import 'package:jellyflut/models/jellyfin/direct_play_profile.dart';
import 'package:jellyflut/models/jellyfin/subtitle_profile.dart';
import 'package:jellyflut/models/jellyfin/transcoding_profile.dart';

import '../globals.dart';

const platform = MethodChannel('com.example.jellyflut/videoPlayer');

const videoProfiles = {
  '3gp': ['h263', 'h264', 'mpeg4', 'hevc'],
  'mp4': ['h263', 'h264', 'mpeg4', 'hevc', 'mpeg2video', 'av1', 'mpeg1video'],
  'ts': ['h264', 'mpeg4'],
  'webm': ['vp8', 'vp9'],
  'mkv': ['h264', 'mpeg4', 'hevc', 'vp8', 'vp9', 'mpeg2video', 'mpeg1video'],
  'flv': ['h264', 'mpeg4'],
  'asf': [
    'mpeg2video',
    'mpeg4',
    'h263',
    'h264',
    'hevc',
    'vp8',
    'vp9',
    'mpeg1video'
  ],
  'm2ts': ['mp2g2video', 'mpeg4', 'h264', 'mpeg1video'],
  'vob': ['mpeg1video', 'mpeg2video'],
  'mov': ['mpeg1video', 'mpeg2video', 'mpeg4', 'h263', 'h264', 'hevc']
};

var audioProfiles = {
  '3gp': ['aac', '3gpp', 'flac'],
  'mp4': ['mp3', 'aac', 'mp1', 'mp2'],
  'ts': ['mp3', 'aac', 'mp1', 'mp2', 'ac3', 'dts'],
  'flac': ['flac'],
  'aac': ['aac'],
  'mkv': [
    'mp3',
    'aac',
    'dts',
    'flac',
    'vorbis',
    'opus',
    'ac3',
    'wma',
    'mp1',
    'mp2'
  ],
  'mp3': ['mp3'],
  'ogg': ['ogg', 'opus', 'vorbis'],
  'webm': ['vorbis', 'opus'],
  'flv': ['mp3', 'aac'],
  'asf': ['aac', 'ac3', 'dts', 'wma', 'flac', 'pcm'],
  'm2ts': ['aac', 'ac3', 'dts', 'pcm'],
  'vob': ['mp1'],
  'mov': ['mp3', 'aac', 'ac3', 'dts-hd', 'pcm']
};

const subtitleProfiles = [
  'ass',
  'idx',
  'pgs',
  'pgssub',
  'smi',
  'srt',
  'ssa',
  'subrip'
];

Future<DeviceProfile> getExoplayerProfile() async {
  final profile = DeviceProfile();
  final db = AppDatabase().getDatabase;
  final settings = await db.settingsDao.getSettingsById(userApp!.settingsId);

  if (savedDeviceProfile != null) {
    return savedDeviceProfile!;
  }

  profile.name = 'Android ${settings.preferredPlayer}';
  profile.maxStreamingBitrate = settings.maxVideoBitrate;
  profile.maxStaticBitrate = 100000000;
  profile.musicStreamingTranscodingBitrate = settings.maxAudioBitrate;

  profile.subtitleProfiles = [];
  profile.directPlayProfiles = [];
  profile.codecProfiles = [];

  for (var sp in subtitleProfiles) {
    profile.subtitleProfiles!.add(SubtitleProfile(format: sp, method: 'Embed'));
  }

  var externalSubtitleProfiles = ['srt', 'sub', 'subrip', 'vtt'];

  for (var sp in externalSubtitleProfiles) {
    profile.subtitleProfiles!
        .add(SubtitleProfile(format: sp, method: 'External'));
  }

  profile.subtitleProfiles!
      .add(SubtitleProfile(format: 'dvdsub', method: 'Encode'));

  var resultString = await platform.invokeMethod('getListOfCodec');
  var result = json.decode(resultString);
  var codecs = DeviceCodecs.fromMap(result);
  var videoCodecs = <Codec>[];
  var audioCodecs = <Codec>[];

  for (var audioCodec in codecs.audioCodecs!) {
    audioCodecs.add(audioCodec);

    var profiles = audioCodec.profiles.join('|');
    var maxChannels = audioCodec.maxChannels;
    var maxSampleRate = audioCodec.maxSampleRate;

    var conditions = <Condition>[];
    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'AudioBitrate',
        value: audioCodec.maxBitrate.toString()));

    conditions.add(Condition(
        condition: 'EqualsAny',
        property: 'AudioProfile',
        value: profiles.toString()));

    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'AudioChannels',
        value: maxChannels.toString()));

    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'AudioSampleRate',
        value: maxSampleRate.toString()));

    profile.codecProfiles!.add(CodecProfile(
        type: 'Audio', codec: audioCodec.codec, conditions: conditions));
  }

  for (var videoCodec in codecs.videoCodecs!) {
    videoCodecs.add(videoCodec);

    var profiles = videoCodec.profiles.join('|');
    var maxLevel;
    if (videoCodec.levels.isNotEmpty) {
      maxLevel = videoCodec.levels.reduce(max);
    }

    var conditions = <Condition>[];
    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'VideoBitrate',
        value: videoCodec.maxBitrate.toString()));

    conditions.add(Condition(
        condition: 'EqualsAny',
        property: 'VideoProfile',
        value: profiles.toString()));

    if (maxLevel != null) {
      conditions.add(Condition(
          condition: 'LessThanEqual',
          property: 'VideoLevel',
          value: maxLevel.toString()));
    }

    if (conditions.isNotEmpty) {
      profile.codecProfiles!.add(CodecProfile(
          type: 'Video', codec: videoCodec.codec, conditions: conditions));
    }
  }

  videoProfiles.forEach((key, value) {
    profile.directPlayProfiles!.add(DirectPlayProfile(
        container: key,
        type: 'Video',
        videoCodec: videoProfiles[key]!
            .where((codec) => videoCodecs.map((e) => e.codec).contains(codec))
            .join(','),
        audioCodec: audioProfiles[key]!
            .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
            .join(',')));
  });

  audioProfiles.forEach((key, value) {
    profile.directPlayProfiles!.add(DirectPlayProfile(
        container: key,
        type: 'Audio',
        audioCodec: audioProfiles[key]!
            .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
            .join(',')));
  });

  profile.transcodingProfiles = getTRanscodingProfiles(audioCodecs);
  savedDeviceProfile = profile;

  return profile;
}

List<TranscodingProfile> getTRanscodingProfiles(List<Codec> audioCodecs) {
  var transcodingProfiles = <TranscodingProfile>[];
  transcodingProfiles.add(TranscodingProfile(
      container: 'ts',
      type: 'Video',
      audioCodec: audioProfiles['ts']!
          .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
          .join(','),
      videoCodec: 'h264',
      context: 'Streaming',
      protocol: 'hls',
      minSegments: 1));
  transcodingProfiles.add(TranscodingProfile(
      container: 'mkv',
      type: 'Video',
      audioCodec: audioProfiles['mkv']!
          .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
          .join(','),
      videoCodec: 'h264',
      context: 'Streaming'));
  transcodingProfiles.add(TranscodingProfile(
      container: 'mp3',
      type: 'Audio',
      audioCodec: 'mp3',
      context: 'Streaming',
      protocol: 'http'));
  return transcodingProfiles;
}
