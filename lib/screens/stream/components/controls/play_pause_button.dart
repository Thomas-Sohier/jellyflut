import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late final StreamingProvider streamingProvider;
  late final VoidCallback listener;
  late final FocusNode _node;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamingProvider.commonStream!.getPlayingStateStream(),
      builder: (context, isPlayingSnapshot) => OutlinedButtonSelector(
          onPressed: () => isPlayingSnapshot.data ?? false
              ? streamingProvider.pause()
              : streamingProvider.play(),
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isPlayingSnapshot.data ?? false ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          )),
    );
  }
}
