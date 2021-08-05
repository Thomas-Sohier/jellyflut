import 'package:flutter/material.dart';
import 'package:jellyflut/provider/streamModel.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late StreamModel streamModel;
  late VoidCallback listener;
  bool isPlaying = true;

  @override
  void initState() {
    streamModel = StreamModel();
    listener = (() {
      setState(() {
        isPlaying = streamModel.commonStream!.isPlaying();
      });
    });
    streamModel.commonStream!.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    streamModel.commonStream!.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          isPlaying
              ? streamModel.commonStream!.pause()
              : streamModel.commonStream!.play();
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
