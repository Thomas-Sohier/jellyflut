import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/controls.dart';
import 'package:wakelock/wakelock.dart';

class Stream extends StatefulWidget {
  final Item item;
  final String streamUrl;
  final PlaybackInfos playbackInfos;

  const Stream(
      {@required this.item,
      @required this.streamUrl,
      @required this.playbackInfos});

  @override
  _StreamState createState() => _StreamState();
}

class PlaybackInfos {}

class _StreamState extends State<Stream> {
  StreamModel streamModel;
  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource dataSource;
  Timer _timer;

  Future<bool> setupData() async {
    dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK, widget.streamUrl,
        subtitles: await getSubtitles(streamModel.item));
    var aspectRatio = int.tryParse(streamModel.item.mediaStreams
        .firstWhere((element) => element.type.trim().toLowerCase() == 'video')
        .aspectRatio
        .replaceAll(':', '/'));
    var betterPlayerConfiguration = BetterPlayerConfiguration(
        aspectRatio: aspectRatio ?? 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: true,
        allowedScreenSleep: false,
        subtitlesConfiguration:
            BetterPlayerSubtitlesConfiguration(fontSize: 18),
        startAt: Duration(
            microseconds:
                (widget.item.userData.playbackPositionTicks / 10).round()),
        showControlsOnInitialize: true,
        controlsConfiguration: configuration());

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.enterFullScreen();
    StreamModel().setBetterPlayerController(_betterPlayerController);
    return Future.value(true);
  }

  @override
  void initState() {
    Wakelock.enable();
    // SystemChrome.setEnabledSystemUIOverlays([]);
    progressTimer();
    streamModel = StreamModel();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    // SystemChrome.setEnabledSystemUIOverlays(
    //     [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<bool>(
        future: setupData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                      controller: streamModel.betterPlayerController)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void progressTimer() {
    _timer = Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => itemProgress(streamModel.item,
            canSeek: true,
            isMuted:
                _betterPlayerController.videoPlayerController.value.volume > 0
                    ? true
                    : false,
            isPaused:
                !_betterPlayerController.videoPlayerController.value.isPlaying,
            positionTicks: _betterPlayerController
                .videoPlayerController.value.position.inMicroseconds,
            volumeLevel: _betterPlayerController
                .videoPlayerController.value.volume
                .round(),
            subtitlesIndex: _betterPlayerController
                .videoPlayerController.value.caption.number));
  }

  BetterPlayerControlsConfiguration configuration() {
    return BetterPlayerControlsConfiguration(
      enableSkips: false,
      enableFullscreen: false,
      enableProgressText: true,
      enablePlaybackSpeed: true,
      enableMute: true,
      enablePlayPause: true,
      enableSubtitles: true,
      enableQualities: false,
      customControls: Controls(),
      controlBarHeight: 40,
    );
  }
}

Future<List<BetterPlayerSubtitlesSource>> getSubtitles(Item item) async {
  var subtitles = StreamModel().playBackInfos.mediaSources.first.mediaStreams !=
          null
      ? StreamModel()
          .playBackInfos
          .mediaSources
          .first
          .mediaStreams
          .where((element) => element.type.trim().toLowerCase() == 'subtitle')
          .toList()
      : [];
  var asyncSubs = subtitles
      .map((sub) async => BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          urls: [
            sub.isExternal
                ? sub.deliveryUrl
                : await getSubtitleURL(item.id, sub.codec, sub.index)
          ],
          selectedByDefault: sub.isDefault,
          name: '${sub.language} - ${sub.title}'))
      .toList();
  return Future.wait(asyncSubs);
}
