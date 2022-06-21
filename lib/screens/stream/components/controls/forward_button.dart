import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class ForwardButton extends StatefulWidget {
  final Duration duration;
  final double? size;
  const ForwardButton(
      {super.key, this.duration = const Duration(seconds: 10), this.size});

  @override
  State<ForwardButton> createState() => _ForwardButtonState();
}

class _ForwardButtonState extends State<ForwardButton> {
  late final StreamingProvider streamingProvider;

  double? get size => widget.size;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: forward,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.fast_forward,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }

  void forward() {
    final currentDuration =
        streamingProvider.commonStream!.getCurrentPosition();
    final seekToDuration =
        (currentDuration ?? widget.duration) + widget.duration;
    streamingProvider.commonStream!.seekTo(seekToDuration);
  }
}
