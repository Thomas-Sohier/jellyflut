import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class FullscreenButton extends StatefulWidget {
  final Duration duration;
  const FullscreenButton(
      {super.key, this.duration = const Duration(seconds: 10)});

  @override
  State<FullscreenButton> createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<FullscreenButton> {
  late bool isFullscreen;
  late final StreamingProvider streamingProvider;
  late final ValueNotifier<bool> _isFullscreen =
      ValueNotifier<bool>(streamingProvider.isFullscreen);

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: toggleFullscreen,
        shape: CircleBorder(),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<bool>(
                valueListenable: _isFullscreen,
                builder: (_, isFullScreen, child) {
                  return Icon(
                    isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  );
                })));
  }

  void toggleFullscreen() {
    _isFullscreen.value = streamingProvider.toggleFullscreen();
  }
}
