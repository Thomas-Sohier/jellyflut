import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
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
    // TODO add a placeholder while loading IPTV, maybe let pass placeholder
    // instead of trying to have a default ugly one
    if (widget.item != null && widget.url == null) {
      videoFuture = InitStreamingItemUtil.initFromItem(item: widget.item!);
    } else if (widget.url != null) {
      videoFuture = InitStreamingUrlUtil.initFromUrl(
          url: widget.url!, streamName: widget.item?.name ?? '');
    }

    videoFuture.catchError((error, stackTrace) {
      customRouter.pop();
      var msg = error.toString();
      if (error is DioError) msg = error.message;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Row(children: [
              Text(msg),
              Spacer(),
              Icon(Icons.play_disabled, color: Colors.red)
            ]),
            width: 600));
      return Future.value(Text(msg));
    });

    if (!Platform.isLinux) {
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
    if (!Platform.isLinux) {
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
