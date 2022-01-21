import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:rxdart/rxdart.dart';

import 'common_controls.dart';

class PlayerInterface extends StatefulWidget {
  final dynamic controller;
  PlayerInterface({Key? key, this.controller}) : super(key: key);

  @override
  _PlayerInterfaceState createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  late final StreamingProvider _streamingProvider;
  late final BehaviorSubject<dynamic> _controllerStream;
  late final StreamSubscription<StreamingEvent> _subEvent;

  @override
  void initState() {
    super.initState();
    _streamingProvider = StreamingProvider();
    _controllerStream = BehaviorSubject<dynamic>.seeded(widget.controller);
    _subEvent = _streamingProvider.streamingEvent.listen((value) {});
    _subEvent.onData((StreamingEvent event) {
      if (event == StreamingEvent.DATASOURCE_CHANGED) {
        _controllerStream.add(_streamingProvider.commonStream?.controller);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        StreamBuilder<dynamic>(
            stream: _controllerStream,
            builder: (c, s) {
              if (s.hasData && s.data != null) {
                return createWidgetController(s.data);
              } else {
                return const SizedBox();
              }
            }),
        CommonControls(),
      ],
    );
  }

  /// Automatically create widget depending of controller provided
  /// Can throw [UnsupportedPlayerException] if controller is not recognized
  Widget createWidgetController(dynamic controller) {
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
        showControls: false,
      );
    } else {
      throw UnsupportedPlayerException('Unknow controller');
    }
  }
}
