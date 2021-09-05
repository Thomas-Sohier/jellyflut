import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/playback_infos.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';

class StreamingProvider extends ChangeNotifier {
  Item? _item;
  PlayBackInfos? _playBackInfos;
  String? _url;
  CommonStream? _commonStream;
  bool? _isDirectPlay;
  AudioTrack? _selectedAudioTrack;
  Subtitle? _selectedSubtitleTrack;
  Timer? _timer;

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

  factory StreamingProvider() {
    return _streamProvider;
  }

  StreamingProvider._internal();

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
  }

  void setSubtitleStreamIndex(Subtitle? subtitleTrack) {
    _selectedSubtitleTrack = subtitleTrack;
  }

  void setTimer(Timer timer) {
    _timer = timer;
  }
}
