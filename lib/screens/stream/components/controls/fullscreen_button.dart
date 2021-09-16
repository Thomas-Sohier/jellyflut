import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class FullscreenButton extends StatefulWidget {
  final Duration duration;
  FullscreenButton({Key? key, this.duration = const Duration(seconds: 10)})
      : super(key: key);

  @override
  _FullscreenButtonState createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<FullscreenButton> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late bool isFullscreen;

  @override
  void initState() {
    _node = FocusNode();
    isFullscreen = false;
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
      node: _node,
      onPressed: toggleFullscreen,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
      ),
    );
  }

  void toggleFullscreen() {
    if (isFullscreen) {
      streamingProvider.commonStream!.exitFullscreen();
      isFullscreen = false;
      setState(() {});
    } else {
      streamingProvider.commonStream!.enterFullscreen();
      isFullscreen = true;
      setState(() {});
    }
  }
}
