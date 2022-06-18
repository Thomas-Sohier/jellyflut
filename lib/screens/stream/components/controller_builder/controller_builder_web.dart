import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:video_player/video_player.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatefulWidget {
  final dynamic controller;
  Controllerbuilder({super.key, required this.controller});

  @override
  State<Controllerbuilder> createState() => _ControllerbuilderState();
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
    if (controller is VideoPlayerController) {
      return VideoPlayer(controller, key: UniqueKey());
    } else {
      throw UnsupportedPlayerException('Unknow controller');
    }
  }
}
