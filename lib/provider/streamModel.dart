import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStream.dart';

class StreamModel extends ChangeNotifier {
  Item? _item;
  PlayBackInfos? _playBackInfos;
  String? _url;
  CommonStream? _commonStream;
  bool? _isDirectPlay;
  int? _audioStreamIndex;
  int? _subtitleStreamIndex;
  Timer? _timer;

  // Singleton
  static final StreamModel _streamProvider = StreamModel._internal();

  Item? get item => _item;
  PlayBackInfos? get playBackInfos => _playBackInfos;
  String? get url => _url;
  CommonStream? get commonStream => _commonStream;
  bool? get isDirectPlay => _isDirectPlay;
  int? get audioStreamIndex => _audioStreamIndex;
  int? get subtitleStreamIndex => _subtitleStreamIndex;
  Timer? get timer => _timer;

  factory StreamModel() {
    return _streamProvider;
  }

  StreamModel._internal();

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

  void setAudioStreamIndex(int audioStreamIndex) {
    _audioStreamIndex = audioStreamIndex;
  }

  void setSubtitleStreamIndex(int subtitleStreamIndex) {
    _subtitleStreamIndex = subtitleStreamIndex;
  }

  void setTimer(Timer timer) {
    _timer = timer;
  }
}
