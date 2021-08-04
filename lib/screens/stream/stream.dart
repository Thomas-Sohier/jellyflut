import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:wakelock/wakelock.dart';

class Stream extends StatefulWidget {
  final Widget player;
  final Item item;

  const Stream({required this.player, required this.item});

  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  late StreamModel streamModel;

  @override
  void initState() {
    Wakelock.enable();
    streamModel = StreamModel();
    // Hide device overlays
    // device orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    streamModel.commonStream?.disposeStream();
    streamModel.timer?.cancel();
    // Show device overlays
    // device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: AspectRatio(
        aspectRatio: widget.item.getAspectRatio(),
        child: widget.player,
      )),
    );
  }
}
