import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class VideoPlayerProgressBar extends StatefulWidget {
  final double barHeight;
  final double thumbRadius;
  final BarCapShape barCapShape;
  const VideoPlayerProgressBar(
      {super.key,
      this.barHeight = 6.0,
      this.thumbRadius = 4.5,
      this.barCapShape = BarCapShape.round});

  @override
  State<VideoPlayerProgressBar> createState() => _VideoPlayerProgressBarState();
}

class _VideoPlayerProgressBarState extends State<VideoPlayerProgressBar> {
  late StreamingProvider streamingProvider;

  double get barHeight => widget.barHeight;
  double get thumbRadius => widget.thumbRadius;
  BarCapShape get barCapShape => widget.barCapShape;

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
          thumbColor: Theme.of(context).colorScheme.onPrimary,
          timeLabelLocation: TimeLabelLocation.none,
          timeLabelTextStyle: TextStyle(color: Colors.white),
          barHeight: barHeight,
          thumbRadius: thumbRadius,
          barCapShape: barCapShape,
          thumbCanPaintOutsideBar: true,
          onSeek: (duration) {
            streamingProvider.commonStream!.seekTo(duration);
          }),
    );
  }
}
