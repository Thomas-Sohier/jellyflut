import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:jellyflut/models/codecProfile.dart';
import 'package:jellyflut/models/condition.dart';
import 'package:jellyflut/models/deviceCodecs.dart';
import 'package:jellyflut/models/deviceProfile.dart';
import 'package:jellyflut/models/directPlayProfile.dart';
import 'package:jellyflut/models/subtitleProfile.dart';
import 'package:jellyflut/models/transcodingProfile.dart';

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

const audioProfiles = {
  '3gp': ['aac', '3gpp', 'flac'],
  'mp4': ['mp3', 'aac', 'mp1', 'mp2'],
  'ts': ['mp3', 'aac', 'mp1', 'mp2'],
  'flac': ['flac'],
  'aac': ['aac'],
  'mkv': ['mp3', 'aac', 'flac', 'vorbis', 'opus', 'wma', 'mp1', 'mp2'],
  'mp3': ['mp3'],
  'ogg': ['ogg', 'opus', 'vorbis'],
  'webm': ['vorbis', 'opus'],
  'flv': ['mp3', 'aac'],
  'asf': ['aac', 'wma', 'flac', 'pcm'],
  'm2ts': ['aac', 'pcm'],
  'vob': ['mp1'],
  'mov': ['mp3', 'aac', 'pcm']
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
  // if (cachedDeviceProfile) {
  //       return (cachedDeviceProfile);
  //   }

  // var bitrateSetting = appSettings.maxStreamingBitrate();

  var profile = DeviceProfile();

  // if (savedDeviceProfile != null) {
  //   return savedDeviceProfile;
  // }

  profile.name = 'Android ExoPlayer';
  profile.maxStreamingBitrate = 120000000;
  profile.maxStaticBitrate = 100000000;
  profile.musicStreamingTranscodingBitrate = 192000;

  profile.subtitleProfiles = [];
  profile.directPlayProfiles = [];
  profile.codecProfiles = [];

  subtitleProfiles.forEach((sp) => profile.subtitleProfiles
      .add(SubtitleProfile(format: sp, method: 'Embed')));

  var externalSubtitleProfiles = ['srt', 'sub', 'subrip', 'vtt'];

  externalSubtitleProfiles.forEach((sp) => profile.subtitleProfiles
      .add(SubtitleProfile(format: sp, method: 'External')));

  profile.subtitleProfiles
      .add(SubtitleProfile(format: 'dvdsub', method: 'Encode'));

  var resultString = await platform.invokeMethod('getListOfCodec');
  var result = json.decode(resultString);
  var codecs = DeviceCodecs.fromMap(result);
  var videoCodecs = <Codec>[];
  var audioCodecs = <Codec>[];
  var transcofingProfiles = getTRanscodingProfiles(audioCodecs);

  codecs.audioCodecs.forEach((audioCodec) {
    audioCodecs.add(audioCodec);

    var profiles = audioCodec.profiles.join('|');
    var maxChannels = audioCodec.maxChannels;
    var maxSampleRate = audioCodec.maxSampleRate;

    var conditions = <Condition>[];
    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'AudioBitrate',
        value: audioCodec.maxBitrate));

    if (profiles != null) {
      conditions.add(Condition(
          condition: 'EqualsAny', property: 'AudioProfile', value: profiles));
    }

    if (maxChannels != null) {
      conditions.add(Condition(
          condition: 'LessThanEqual',
          property: 'AudioChannels',
          value: maxChannels));
    }

    if (maxSampleRate != null) {
      conditions.add(Condition(
          condition: 'LessThanEqual',
          property: 'AudioSampleRate',
          value: maxSampleRate));
    }

    profile.codecProfiles.add(CodecProfile(
        type: 'Audio', codec: audioCodec.codec, conditions: conditions));
  });

  codecs.videoCodecs.forEach((videoCodec) {
    videoCodecs.add(videoCodec);

    var profiles = videoCodec.profiles.join('|');
    var maxLevel =
        videoCodec.levels.isNotEmpty ?? videoCodec.levels.reduce(max);

    var conditions = <Condition>[];
    conditions.add(Condition(
        condition: 'LessThanEqual',
        property: 'VideoBitrate',
        value: videoCodec.maxBitrate));

    if (profiles != null) {
      conditions.add(Condition(
          condition: 'EqualsAny', property: 'VideoProfile', value: profiles));
    }

    if (maxLevel != null) {
      conditions.add(Condition(
          condition: 'LessThanEqual', property: 'VideoLevel', value: maxLevel));
    }

    if (conditions.isNotEmpty) {
      profile.codecProfiles.add(CodecProfile(
          type: 'Video', codec: videoCodec.codec, conditions: conditions));
    }
  });

  videoProfiles.forEach((key, value) {
    profile.directPlayProfiles.add(DirectPlayProfile(
        container: key,
        type: 'Video',
        videoCodec: videoProfiles[key]
            .where((codec) => videoCodecs.map((e) => e.codec).contains(codec))
            .join(','),
        audioCodec: audioProfiles[key]
            .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
            .join(',')));
  });

  audioProfiles.forEach((key, value) {
    profile.directPlayProfiles.add(DirectPlayProfile(
        container: key,
        type: 'Audio',
        audioCodec: audioProfiles[key]
            .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
            .join(',')));
  });

  profile.transcodingProfiles = transcofingProfiles;
  savedDeviceProfile = profile;

  return profile;
}

List<TranscodingProfile> getTRanscodingProfiles(List<Codec> audioCodecs) {
  var transcodingProfiles = <TranscodingProfile>[];
  transcodingProfiles.add(TranscodingProfile(
      container: 'ts',
      type: 'Video',
      audioCodec: audioProfiles['ts']
          .where((codec) => audioCodecs.map((e) => e.codec).contains(codec))
          .join(','),
      videoCodec: 'h264',
      context: 'Streaming',
      protocol: 'hls',
      minSegments: 1));
  transcodingProfiles.add(TranscodingProfile(
      container: 'mkv',
      type: 'Video',
      audioCodec: audioProfiles['mkv']
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
