import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:wakelock/wakelock.dart';

class Stream extends StatefulWidget {
  final Widget player;
  final Item item;

  const Stream({required this.player, required this.item});

  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  late final StreamingProvider streamingProvider;

  @override
  void initState() {
    super.initState();
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      Wakelock.enable();
    }
    streamingProvider = StreamingProvider();
    // Hide device overlays
    // device orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      Wakelock.disable();
    }
    streamingProvider.commonStream?.disposeStream();
    streamingProvider.timer?.cancel();
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
  void deactivate() {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      Wakelock.disable();
    }
    streamingProvider.commonStream?.disposeStream();
    streamingProvider.timer?.cancel();
    // Show device overlays
    // device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: widget.player),
    );
  }
}
