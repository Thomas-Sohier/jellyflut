import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/shared/theme.dart';

class VideoPlayerProgressBar extends StatefulWidget {
  VideoPlayerProgressBar({Key? key}) : super(key: key);

  @override
  _VideoPlayerProgressBarState createState() => _VideoPlayerProgressBarState();
}

class _VideoPlayerProgressBarState extends State<VideoPlayerProgressBar> {
  late StreamingProvider streamingProvider;
  late VoidCallback listener;
  Duration playbackTime = Duration(seconds: 0);

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    listener = (() {
      setState(() {
        playbackTime = streamingProvider.commonStream!.getCurrentPosition();
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
    return ProgressBar(
        progress: playbackTime,
        buffered: streamingProvider.commonStream!.getBufferingDuration(),
        total: streamingProvider.commonStream!.getDuration(),
        progressBarColor: jellyLightPurple,
        baseBarColor: Colors.white.withOpacity(0.24),
        bufferedBarColor: Colors.white.withOpacity(0.24),
        thumbColor: Colors.white,
        timeLabelTextStyle: TextStyle(color: Colors.white),
        barHeight: 3.0,
        thumbRadius: 5.0,
        onSeek: (duration) {
          streamingProvider.commonStream!.seekTo(duration);
        });
  }
}
