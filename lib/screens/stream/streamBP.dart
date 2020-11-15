import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:wakelock/wakelock.dart';

import 'controls.dart';

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
    streamModel = StreamModel();
    streamModel.startProgressTimer();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    streamModel.stopProgressTimer();
    streamModel.dispose();
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
          selectedByDefault: StreamModel().subtitleStreamIndex == sub.index,
          name: '${sub.language} - ${sub.title}'))
      .toList();
  return Future.wait(asyncSubs);
}
