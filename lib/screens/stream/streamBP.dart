import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/controlsBP.dart';
import 'package:jellyflut/shared/toast.dart';
import 'package:wakelock/wakelock.dart';

import '../../main.dart';

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
  StreamController<bool> _placeholderStreamController;
  Timer _timer;
  FToast fToast;
  final GlobalKey _betterPlayerKey = GlobalKey();
  var aspectRatio;
  final Orientation currentOrientation =
      MediaQuery.of(navigatorKey.currentContext).orientation;

  Future<bool> setupData() async {
    dataSource = BetterPlayerDataSource.network(
      widget.streamUrl,
      subtitles: await getSubtitles(streamModel.item),
    );
    aspectRatio = streamModel.item.getAspectRatio();

    _betterPlayerController = BetterPlayerController(
        setupPlayerControllerConfiguration(
            aspectRatio: aspectRatio,
            startAt: widget.item.getPlaybackPosition(),
            customConfiguration: configuration()));
    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    streamModel.setBetterPlayerController(_betterPlayerController);
    return Future.value(true);
  }

  void playerError() {
    if (_betterPlayerController.videoPlayerController.value.hasError) {
      print(
          _betterPlayerController.videoPlayerController.value.errorDescription);
    }
  }

  @override
  void initState() {
    Wakelock.enable();
    _placeholderStreamController = StreamController.broadcast();
    streamModel = StreamModel();
    fToast = FToast();
    fToast.init(navigatorKey.currentState.context);
    // Hide device overlays
    // device orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    if (currentOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    // deleteActiveEncoding();
    _placeholderStreamController.close();
    // _timer?.cancel();
    _betterPlayerController?.dispose();
    // Show device overlays
    // device orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: SystemUiOverlay.values);
    if (currentOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([]);
    }
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
                  aspectRatio: aspectRatio,
                  child: BetterPlayer(
                      key: _betterPlayerKey,
                      controller: streamModel.betterPlayerController)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _startProgressTimer() {
    _timer = Timer.periodic(
        Duration(seconds: 15),
        (Timer
                t) =>
            itemProgress(streamModel.item,
                canSeek: true,
                isMuted:
                    streamModel.betterPlayerController.videoPlayerController.value
                                .volume >
                            0
                        ? true
                        : false,
                isPaused: !streamModel.betterPlayerController.videoPlayerController
                    .value.isPlaying,
                positionTicks: streamModel.betterPlayerController
                    .videoPlayerController.value.position.inMicroseconds,
                volumeLevel: streamModel
                    .betterPlayerController.videoPlayerController.value.volume
                    .round(),
                subtitlesIndex: 0));
  }

  BetterPlayerConfiguration setupPlayerControllerConfiguration(
      {double aspectRatio = 16 / 9,
      int startAt = 0,
      BetterPlayerControlsConfiguration customConfiguration}) {
    return BetterPlayerConfiguration(
        aspectRatio: aspectRatio,
        eventListener: (event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
            Navigator.pop(context);
            showToast(event.parameters.toString(), fToast,
                duration: Duration(seconds: 3));
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.initialized) {
            _startProgressTimer();
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.finished) {
            deleteActiveEncoding();
            _timer?.cancel();
          }
        },
        fit: BoxFit.contain,
        autoPlay: true,
        autoDispose: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        subtitlesConfiguration:
            BetterPlayerSubtitlesConfiguration(fontSize: 18),
        startAt: Duration(microseconds: startAt),
        controlsConfiguration: customConfiguration ?? configuration());
  }
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
    showControlsOnInitialize: true,
    playerTheme: BetterPlayerTheme.custom,
    customControlsBuilder: (controller) => ControlsBP(),
    controlBarHeight: 40,
  );
}

Future<List<BetterPlayerSubtitlesSource>> getSubtitles(Item item) async {
  var asyncSubs = StreamModel()
      .playBackInfos
      .getSubtitles()
      .map((sub) async => BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [
            sub.isExternal
                ? sub.deliveryUrl
                : await getSubtitleURL(item.id, 'vtt', sub.index)
          ],
          selectedByDefault: StreamModel().subtitleStreamIndex == sub.index,
          name: '${sub.language} - ${sub.title}'))
      .toList();
  return Future.wait(asyncSubs);
}
