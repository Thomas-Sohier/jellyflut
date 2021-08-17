import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late StreamingProvider streamingProvider;
  late VoidCallback listener;
  bool isPlaying = true;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    listener = (() {
      setState(() {
        isPlaying = streamingProvider.commonStream!.isPlaying();
      });
    });
    streamingProvider.commonStream!.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    streamingProvider.commonStream!.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          isPlaying
              ? streamingProvider.commonStream!.pause()
              : streamingProvider.commonStream!.play();
        },
        borderRadius: BorderRadius.all(Radius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ));
  }
}
