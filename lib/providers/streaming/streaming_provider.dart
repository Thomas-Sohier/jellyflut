import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/playback_infos.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/screens/stream/init_stream/init_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/media_type.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart'
    as streaming_subtitle;
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:subtitle/subtitle.dart' hide Subtitle;

class StreamingProvider {
  Item? _item;
  PlayBackInfos? _playBackInfos;
  String? _url;
  CommonStream? _commonStream;
  bool _isDirectPlay = true;
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

  bool toggleFullscreen() {
    if (isFullscreen) {
      commonStream?.exitFullscreen();
      _isFullScreen = false;
    } else {
      commonStream?.enterFullscreen();
      _isFullScreen = true;
    }
    return _isFullScreen;
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

  void setAudioStreamIndex(AudioTrack audioTrack) async {
    _selectedAudioTrack = audioTrack;

    if (audioTrack.mediaType == MediaType.REMOTE && item != null) {
      await changeDataSource();
    } else if (audioTrack.mediaType == MediaType.LOCAL) {
      await commonStream?.setAudioTrack(audioTrack);
    }

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.AUDIO_TRACK_SELECTED);
    }
  }

  Future<void> changeDataSource() async {
    return StreamingService.deleteActiveEncoding()
        .then((_) async => await commonStream?.dispose())
        .then((_) => InitStreamingItemUtil.initControllerFromItem(item: item!))
        .then((controller) {
      _commonStream?.controller = controller;
      streamingEvent.add(StreamingEvent.DATASOURCE_CHANGED);
    });
  }

  Future<List<AudioTrack>> getAudioTracks() async {
    final audioTracks = <AudioTrack>[];
    final localAudioTracks = await commonStream?.getAudioTracks() ?? [];
    audioTracks.addAll(localAudioTracks);
    final lastIndex = audioTracks.map((e) => e.index).fold(0, max);
    audioTracks.addAll(_getRemoteAudiotracks(lastIndex + 1));

    return audioTracks;
  }

  List<AudioTrack> _getRemoteAudiotracks([final int startIndex = 0]) {
    final audioTracks = <AudioTrack>[];

    if (isDirectPlay ?? false) return audioTracks;

    final remoteAudioTracksMediaStream = item?.mediaStreams
        .where((e) => e.type == MediaStreamType.AUDIO)
        .toList();

    if (remoteAudioTracksMediaStream != null &&
        remoteAudioTracksMediaStream.isNotEmpty) {
      for (var i = 0; i < remoteAudioTracksMediaStream.length; i++) {
        final at = remoteAudioTracksMediaStream[i];
        final remoteAudioTrack = AudioTrack(
            index: audioTracks.length + startIndex,
            name: at.displayTitle ?? '',
            mediaType: MediaType.REMOTE,
            jellyfinSubtitleIndex: at.index);
        audioTracks.add(remoteAudioTrack);
      }
    }
    return audioTracks;
  }

  Future<List<streaming_subtitle.Subtitle>> getSubtitles() async {
    final subtitles = <streaming_subtitle.Subtitle>[];
    final localSubtitles = await commonStream?.getSubtitles() ?? [];
    subtitles.addAll(localSubtitles);
    final lastIndex = subtitles.map((e) => e.index).fold(0, max);
    subtitles.addAll(_getRemoteSubtitles(lastIndex + 1));

    return subtitles;
  }

  List<streaming_subtitle.Subtitle> _getRemoteSubtitles(
      [final int startIndex = 0]) {
    final subtitles = <streaming_subtitle.Subtitle>[];
    final remoteSubtitlesMediaStream = item?.mediaStreams
        .where((e) => e.type == MediaStreamType.SUBTITLE)
        .toList();

    if (remoteSubtitlesMediaStream != null &&
        remoteSubtitlesMediaStream.isNotEmpty) {
      for (var i = 0; i < remoteSubtitlesMediaStream.length; i++) {
        final ls = remoteSubtitlesMediaStream[i];
        final remoteSubtitle = streaming_subtitle.Subtitle(
            index: subtitles.length + startIndex,
            name: ls.displayTitle ?? '',
            mediaType: MediaType.REMOTE,
            jellyfinSubtitleIndex: ls.index);
        subtitles.add(remoteSubtitle);
      }
    }
    return subtitles;
  }

  Future<SubtitleController?> getSub(
      streaming_subtitle.Subtitle? subtitle) async {
    if (subtitle == null || subtitle.index == -1) return null;

    final subUrl = StreamingService.getSubtitleURL(
        item!.id, 'vtt', subtitle.jellyfinSubtitleIndex!);

    return await Dio()
        .get<dynamic>(subUrl)
        .then<SubtitleController>((subFile) async {
      final controller = SubtitleController(
          provider: SubtitleProvider.fromString(
        data: subFile.data ?? '',
        type: SubtitleType.vtt,
      ));

      await controller.initial();
      return controller;
    });
  }

  void setSubtitleStreamIndex(Subtitle subtitleTrack) {
    _selectedSubtitleTrack = subtitleTrack;

    if (subtitleTrack.mediaType == MediaType.LOCAL) {
      commonStream?.setSubtitle(subtitleTrack);
    }

    if (streamingEvent.hasListener) {
      streamingEvent.add(StreamingEvent.SUBTITLE_SELECTED);
    }
  }

  void setTimer(Timer timer) {
    _timer = timer;
  }
}
