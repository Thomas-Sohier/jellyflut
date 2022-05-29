import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class VideoPlayerProgressBar extends StatefulWidget {
  VideoPlayerProgressBar({super.key});

  @override
  _VideoPlayerProgressBarState createState() => _VideoPlayerProgressBarState();
}

class _VideoPlayerProgressBarState extends State<VideoPlayerProgressBar> {
  late StreamingProvider streamingProvider;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: streamingProvider.commonStream!.getPositionStream(),
      builder: (context, snapshot) => ProgressBar(
          progress: snapshot.data ?? Duration(seconds: 0),
          buffered: streamingProvider.commonStream!.getBufferingDuration(),
          total: streamingProvider.commonStream!.getDuration() ??
              Duration(seconds: 0),
          progressBarColor: Theme.of(context).colorScheme.primary,
          baseBarColor: Colors.white.withOpacity(0.24),
          bufferedBarColor: Colors.white.withOpacity(0.24),
          thumbColor: Colors.white,
          timeLabelTextStyle: TextStyle(color: Colors.white),
          barHeight: 3.0,
          thumbRadius: 5.0,
          onSeek: (duration) {
            streamingProvider.commonStream!.seekTo(duration);
          }),
    );
  }
}
