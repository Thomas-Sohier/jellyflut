import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/controlsVLC.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:wakelock/wakelock.dart';

class StreamVLC extends StatefulWidget {
  final VlcPlayerController controller;
  final bool showControls;

  StreamVLC({
    Key key,
    @required this.controller,
    this.showControls = true,
  })  : assert(controller != null, 'You must provide a vlc controller'),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _StreamVLCState();
}

class _StreamVLCState extends State<StreamVLC>
    with AutomaticKeepAliveClientMixin {
  VlcPlayerController _controller;
  StreamModel streamModel;
  Timer _timer;

  //
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;

  // slider
  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;
  Orientation currentOrientation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Wakelock.enable();
    streamModel = StreamModel();
    _controller = widget.controller;
    _controller.addListener(listener);
    _startProgressTimer();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  @override
  void dispose() {
    Wakelock.disable();
    _controller.removeListener(listener);
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (currentOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
    super.dispose();
  }

  void listener() async {
    if (!mounted) return;
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oPosition != null && oDuration != null) {
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
        }
        sliderValue = _controller.value.position.inSeconds.toDouble();
      }
      numberOfCaptions = _controller.value.spuTracksCount;
      numberOfAudioTracks = _controller.value.audioTracksCount;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                VlcPlayer(
                  controller: _controller,
                  aspectRatio: streamModel.item.getAspectRatio(),
                  placeholder: Center(child: CircularProgressIndicator()),
                ),
                SizedBox(
                    height: size.width / streamModel.item.getAspectRatio(),
                    child: ControlsVLC(
                      controller: _controller,
                    )),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget gradientMask({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.5,
          colors: <Color>[jellyLightBLue, jellyLightPurple],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }

  void _startProgressTimer() {
    _timer = Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => itemProgress(streamModel.item,
            canSeek: true,
            isMuted: _controller.value.volume > 0 ? true : false,
            isPaused: !_controller.value.isPlaying,
            positionTicks: _controller.value.position.inMicroseconds,
            volumeLevel: _controller.value.volume.round(),
            subtitlesIndex: 0));
  }
}
