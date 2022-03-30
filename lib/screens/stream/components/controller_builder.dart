import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatefulWidget {
  final dynamic controller;
  Controllerbuilder({Key? key, required this.controller}) : super(key: key);

  @override
  _ControllerbuilderState createState() => _ControllerbuilderState();
}

class _ControllerbuilderState extends State<Controllerbuilder> {
  late dynamic controller;
  late final StreamingProvider _streamingProvider;
  late final StreamSubscription<StreamingEvent> _subEvent;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    _streamingProvider = StreamingProvider();
    _subEvent = _streamingProvider.streamingEvent.listen((value) {});
    _subEvent.onData((StreamingEvent event) {
      if (event == StreamingEvent.DATASOURCE_CHANGED) {
        setState(
            () => controller = _streamingProvider.commonStream?.controller);
      }
    });
  }

  @override
  void dispose() {
    _subEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller is BetterPlayerController) {
      return BetterPlayer(
          key: controller.betterPlayerGlobalKey, controller: controller);
    } else if (controller is VlcPlayerController) {
      return VlcPlayer(
          controller: controller,
          aspectRatio: 16 / 9,
          placeholder: Center(child: CircularProgressIndicator()));
    } else if (controller is Player) {
      return Video(
        player: controller,
        playlistLength: 0,
        showControls: false,
      );
    } else {
      throw UnsupportedPlayerException('Unknow controller');
    }
  }
}
