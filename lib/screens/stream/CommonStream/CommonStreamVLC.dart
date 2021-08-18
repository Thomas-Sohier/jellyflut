import 'dart:async';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStream.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streamingService.dart';
import 'package:rxdart/rxdart.dart';

class CommonStreamVLC {
  static Duration getBufferingDurationVLC(
      VlcPlayerController vlcPlayerController) {
    final durationCurrentFile = vlcPlayerController.value.duration;
    final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds =
        totalMilliseconds / vlcPlayerController.value.bufferPercent;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN ||
                currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  static Future<VlcPlayerController> setupData({required Item item}) async {
    final streamURL = await item.getItemURL(directPlay: true);

    // Create vlcPlayerController
    final vlcPlayerController = VlcPlayerController.network(
      streamURL,
      autoPlay: true,
      options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          extras: [
            '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}' // Start at x seconds
          ]),
    );

    // create timer to save progress
    final timer = _startProgressTimer(item, vlcPlayerController);
    StreamingProvider().setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parseVLCController(
        vlcPlayerController: vlcPlayerController, listener: () => {});

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(vlcPlayerController);
  }

  static Future<VlcPlayerController> setupDataFromUrl(
      {required String url}) async {
    // Create vlcPlayerController
    final vlcPlayerController = VlcPlayerController.network(
      url,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
      ),
    );

    // create common stream controller
    final commonStream = CommonStream.parseVLCController(
        vlcPlayerController: vlcPlayerController, listener: () => {});

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(vlcPlayerController);
  }

  static Timer _startProgressTimer(
      Item item, VlcPlayerController vlcPlayerController) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => StreamingService.streamingProgress(item,
            canSeek: true,
            isMuted: vlcPlayerController.value.volume > 0 ? true : false,
            isPaused: !vlcPlayerController.value.isPlaying,
            positionTicks: vlcPlayerController.value.position.inMicroseconds,
            volumeLevel: vlcPlayerController.value.volume.round(),
            subtitlesIndex: 0));
  }

  static Future<List<Subtitle>> getSubtitles(
      VlcPlayerController vlcPlayerController) async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = await vlcPlayerController.getSpuTracks();
    for (var i = 0; i < subtitles.length; i++) {
      final subtitleKey = subtitles.keys.elementAt(i);
      parsedSubtitiles.add(Subtitle(
          index: i,
          jellyfinSubtitleIndex: subtitleKey,
          name: subtitles[subtitleKey]!));
    }
    return parsedSubtitiles;
  }

  static void setSubtitle(
      Subtitle subtitle, VlcPlayerController vlcPlayerController) {
    vlcPlayerController.setSpuTrack(subtitle.jellyfinSubtitleIndex!);
  }

  static Future<List<AudioTrack>> getAudioTracks(
      VlcPlayerController vlcPlayerController) async {
    // ignore: omit_local_variable_types
    final List<AudioTrack> parsedAudioTracks = [];
    final audioTracks = await vlcPlayerController.getAudioTracks();
    for (var i = 0; i < audioTracks.length; i++) {
      final audioTrackKey = audioTracks.keys.elementAt(i);
      parsedAudioTracks.add(AudioTrack(
          index: i,
          jellyfinSubtitleIndex: audioTrackKey,
          name: audioTracks[audioTrackKey]!));
    }
    return parsedAudioTracks;
  }

  static void setAudioTrack(
      AudioTrack trackIndex, VlcPlayerController vlcPlayerController) {
    vlcPlayerController.setAudioTrack(trackIndex.jellyfinSubtitleIndex!);
  }

  static BehaviorSubject<Duration> positionStream(
      VlcPlayerController vlcPlayerController) {
    final streamController = BehaviorSubject<Duration>();
    vlcPlayerController.addListener(() {
      streamController.add(vlcPlayerController.value.position);
    });
    return streamController;
  }

  static BehaviorSubject<Duration> durationStream(
      VlcPlayerController vlcPlayerController) {
    final streamController = BehaviorSubject<Duration>();
    vlcPlayerController.addListener(() {
      streamController.add(vlcPlayerController.value.duration);
    });
    return streamController;
  }
}
