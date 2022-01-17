import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/playback_infos.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/media_type.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:rxdart/subjects.dart';

class StreamingProvider extends ChangeNotifier {
  Item? _item;
  PlayBackInfos? _playBackInfos;
  String? _url;
  CommonStream? _commonStream;
  bool? _isDirectPlay;
  AudioTrack? _selectedAudioTrack;
  Subtitle? _selectedSubtitleTrack;
  Timer? _timer;
  bool _isFullScreen = false;
  late BehaviorSubject<StreamingEvent> streamingEvent;

  // Singleton
  static final StreamingProvider _streamProvider =
      StreamingProvider._internal();

  Item? get item => _item;
  PlayBackInfos? get playBackInfos => _playBackInfos;
  String? get url => _url;
  CommonStream? get commonStream => _commonStream;
  bool? get isDirectPlay => _isDirectPlay;
  AudioTrack? get selectedAudioTrack => _selectedAudioTrack;
  Subtitle? get selectedSubtitleTrack => _selectedSubtitleTrack;
  Timer? get timer => _timer;
  bool get isFullscreen => _isFullScreen;

  factory StreamingProvider() {
    return _streamProvider;
  }

  StreamingProvider._internal() {
    streamingEvent = BehaviorSubject();
  }

  void play() {
    commonStream?.play();

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.PLAY);
    }
  }

  void pause() {
    commonStream?.pause();

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.PAUSE);
    }
  }

  void toggleFullscreen() {
    if (isFullscreen) {
      commonStream?.exitFullscreen();
      _isFullScreen = false;
    } else {
      commonStream?.enterFullscreen();
      _isFullScreen = true;
    }
  }

  void enterFullscreen() {
    commonStream?.enterFullscreen();
    _isFullScreen = true;
  }

  void exitFullscreen() {
    commonStream?.exitFullscreen();
    _isFullScreen = false;
  }

  void setItem(Item item) {
    _item = item;
  }

  void setPlaybackInfos(PlayBackInfos playBackInfos) {
    _playBackInfos = playBackInfos;
  }

  void setURL(String url) {
    _url = url;
  }

  void setCommonStream(CommonStream commonStream) {
    _commonStream = commonStream;
  }

  void setIsDirectPlay(bool isDirectPlay) {
    _isDirectPlay = isDirectPlay;
  }

  void setAudioStreamIndex(AudioTrack? audioTrack) {
    _selectedAudioTrack = audioTrack;

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.AUDIO_TRACK_SELECTED);
    }
  }

  Future<List<Subtitle>> getSubtitles() async {
    final subtitles = await commonStream?.getSubtitles() ?? <Subtitle>[];

    final remoteSubtitlesMediaStream = item?.mediaStreams
        .where((e) => e.type == MediaStreamType.SUBTITLE)
        .toList();

    if (remoteSubtitlesMediaStream != null &&
        remoteSubtitlesMediaStream.isNotEmpty) {
      for (var i = 0; i < remoteSubtitlesMediaStream.length; i++) {
        final ls = remoteSubtitlesMediaStream[i];
        subtitles.add(Subtitle(
            index: subtitles.length,
            name: ls.title ?? '',
            mediaType: MediaType.REMOTE,
            jellyfinSubtitleIndex: ls.index));
      }
    }

    return subtitles;
  }

  void setSubtitleStreamIndex(Subtitle? subtitleTrack) {
    _selectedSubtitleTrack = subtitleTrack;

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.SUBTITLE_SELECTED);
    }
  }

  void setTimer(Timer timer) {
    _timer = timer;
  }
}
