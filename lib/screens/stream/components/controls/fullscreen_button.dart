import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:provider/provider.dart';

class FullscreenButton extends StatefulWidget {
  final Duration duration;
  FullscreenButton({Key? key, this.duration = const Duration(seconds: 10)})
      : super(key: key);

  @override
  _FullscreenButtonState createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<FullscreenButton> {
  late bool isFullscreen;
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;

  @override
  void initState() {
    _node = FocusNode();
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: toggleFullscreen,
      shape: CircleBorder(),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChangeNotifierProvider.value(
              value: streamingProvider,
              child: Icon(
                streamingProvider.isFullscreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                color: Colors.white,
              ))),
    );
  }

  void toggleFullscreen() {
    streamingProvider.toggleFullscreen();
  }
}
