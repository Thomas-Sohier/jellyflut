import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';

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
    streamingProvider.commonStream!.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamingProvider.commonStream!.getPlayingStateStream(),
      builder: (context, isPlayingSnapshot) => OutlinedButtonSelector(
          node: _node,
          onPressed: () => isPlayingSnapshot.data!
              ? streamingProvider.commonStream!.pause()
              : streamingProvider.commonStream!.play(),
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isPlayingSnapshot.data! ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          )),
    );
  }
}
