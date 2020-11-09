import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:wakelock/wakelock.dart';

import '../../globals.dart';

class Stream extends StatefulWidget {
  final Item item;
  final String streamUrl;

  const Stream({@required this.item, @required this.streamUrl});

  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  StreamModel streamModel;
  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource dataSource;
  Timer _timer;

  Future<BetterPlayerController> setupData() async {
    dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK, widget.streamUrl,
        subtitles: await getSubtitles(widget.item));

    var betterPlayerConfiguration = BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        showControlsOnInitialize: true,
        controlsConfiguration: configuration());

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    await _betterPlayerController.setupDataSource(dataSource);
    return Future.value(_betterPlayerController);
  }

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIOverlays([]);
    progressTimer();
    streamModel = StreamModel();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<BetterPlayerController>(
        future: setupData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(controller: snapshot.data)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void progressTimer() {
    if (_betterPlayerController != null) {
      _timer = Timer.periodic(
          Duration(seconds: 15),
          (Timer t) => itemProgress(streamModel.item,
              canSeek: true,
              isMuted:
                  _betterPlayerController.videoPlayerController.value.volume > 0
                      ? true
                      : false,
              isPaused: !_betterPlayerController
                  .videoPlayerController.value.isPlaying,
              positionTicks: _betterPlayerController
                  .videoPlayerController.value.position.inMicroseconds,
              volumeLevel: _betterPlayerController
                  .videoPlayerController.value.volume
                  .round(),
              subtitlesIndex: _betterPlayerController
                  .videoPlayerController.value.caption.number));
    }
  }

  BetterPlayerControlsConfiguration configuration() {
    return BetterPlayerControlsConfiguration(
      enableSkips: false,
      enableFullscreen: true,
      enablePlaybackSpeed: true,
      enableMute: true,
      enablePlayPause: true,
      enableQualities: false,
      controlBarHeight: 40,
    );
  }
}

Future<List<BetterPlayerSubtitlesSource>> getSubtitles(Item item) async {
  var subtitles = item?.mediaStreams != null
      ? item.mediaStreams
          .where((element) => element.type.toString() == 'Type.SUBTITLE')
          .toList()
      : [];
  var asyncSubs = subtitles
      .map((sub) async => BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          urls: [
            await getSubtitleURL(item.id, sub.codec.toString(), sub.index)
          ],
          name: sub.title))
      .toList();
  return Future.wait(asyncSubs);
}

Future<String> getSubtitleURL(
    String itemId, String codec, int subtitleId) async {
  var mediaSourceId = itemId.substring(0, 8) +
      '-' +
      itemId.substring(8, 12) +
      '-' +
      itemId.substring(12, 16) +
      '-' +
      itemId.substring(16, 20) +
      '-' +
      itemId.substring(20, itemId.length);

  var parsedCodec = codec.substring(codec.indexOf('.') + 1);

  var queryParam = <String, String>{};
  queryParam['api_key'] = apiKey;

  var uri = Uri.https(
      server.url.replaceAll('https://', ''),
      '/Videos/${mediaSourceId}/${itemId}/Subtitles/${subtitleId}/0/Stream.${parsedCodec}',
      queryParam);
  return uri.origin + uri.path;
}
