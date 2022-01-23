import 'dart:async';
import 'dart:io';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/media_type.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';

class CommonStreamVLC {
  static final streamingProvider = StreamingProvider();
  final VlcPlayerController vlcPlayerController;

  const CommonStreamVLC({required this.vlcPlayerController});

  Duration getBufferingDurationVLC() {
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
    final streamingProvider = StreamingProvider();
    final streamURL = await item.getItemURL();

    // Detect if media is available locdally or only remotely
    late final vlcPlayerController;
    if (streamURL.startsWith(RegExp('^(http|https)://'))) {
      vlcPlayerController = VlcPlayerController.network(
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
    } else {
      vlcPlayerController = VlcPlayerController.file(
        File(streamURL),
        autoPlay: true,
        options: VlcPlayerOptions(
            advanced: VlcAdvancedOptions([
              VlcAdvancedOptions.networkCaching(2000),
            ]),
            extras: [
              '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}' // Start at x seconds
            ]),
      );
    }

    // create timer to save progress
    final timer = _startProgressTimer(item, vlcPlayerController);
    streamingProvider.timer?.cancel();
    streamingProvider.setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parseVLCController(
        vlcPlayerController: vlcPlayerController, listener: () => {});

    streamingProvider.setCommonStream(commonStream);
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

  Future<List<Subtitle>> getSubtitles() async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = await vlcPlayerController.getSpuTracks();
    for (var i = 0; i < subtitles.length; i++) {
      final subtitleKey = subtitles.keys.elementAt(i);
      parsedSubtitiles.add(Subtitle(
          index: subtitleKey,
          mediaType: MediaType.LOCAL,
          jellyfinSubtitleIndex: null,
          name: subtitles[subtitleKey]!));
    }
    return parsedSubtitiles;
  }

  Future<List<AudioTrack>> getAudioTracks() async {
    // ignore: omit_local_variable_types
    final List<AudioTrack> parsedAudioTracks = [];
    final audioTracks = await vlcPlayerController.getAudioTracks();
    for (var i = 0; i < audioTracks.length; i++) {
      final audioTrackKey = audioTracks.keys.elementAt(i);
      parsedAudioTracks.add(AudioTrack(
          index: i,
          mediaType: MediaType.LOCAL,
          jellyfinSubtitleIndex: audioTrackKey,
          name: audioTracks[audioTrackKey]!));
    }
    return parsedAudioTracks;
  }

  void setAudioTrack(
    AudioTrack trackIndex,
  ) {
    vlcPlayerController.setAudioTrack(trackIndex.jellyfinSubtitleIndex!);
  }

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    vlcPlayerController.addListener(() {
      streamController.add(vlcPlayerController.value.position);
    });
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    vlcPlayerController.addListener(() {
      streamController.add(vlcPlayerController.value.duration);
    });
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    vlcPlayerController.addListener(
        () => streamController.add(vlcPlayerController.value.isPlaying));
    return streamController;
  }

  Future<void> stopPlayer() async {
    await StreamingService.deleteActiveEncoding();
    await vlcPlayerController.stop();
    return await vlcPlayerController.dispose();
  }
}
