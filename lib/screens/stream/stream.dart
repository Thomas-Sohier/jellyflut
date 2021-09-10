import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/components/placeholder_screen.dart';
import 'package:wakelock/wakelock.dart';

import 'init_stream.dart';

class Stream extends StatefulWidget {
  final Item? item;
  final String? url;

  const Stream({this.item, this.url});

  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  late final StreamingProvider streamingProvider;
  late final Future<Widget> videoFuture;

  @override
  void initState() {
    super.initState();
    // if we have an item but no url then we strem from item
    // else we use the url if there is one to stream from it
    if (widget.item != null && widget.url == null) {
      videoFuture = InitStreamingItemUtil.initFromItem(item: widget.item!);
    } else if (widget.url != null) {
      videoFuture = InitStreamingUrlUtil.initFromUrl(
          url: widget.url!, streamName: widget.item?.name ?? '');
    }

    if (!(Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      Wakelock.enable();
    }
    streamingProvider = StreamingProvider();
    // Hide device overlays
    // device orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    if (!(Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  // TODO remove this when dispose dart vlc will work correctly on all platform
  // @override
  // void deactivate() {
  //   if (!(Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
  //     Wakelock.disable();
  //   }
  //   streamingProvider.commonStream?.disposeStream();
  //   streamingProvider.timer?.cancel();
  //   // Show device overlays
  //   // device orientation
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight
  //   ]);
  //   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Widget>(
        future: videoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child: snapshot.data);
          }
          return PlaceholderScreen(item: widget.item);
        },
      ),
    );
  }
}
