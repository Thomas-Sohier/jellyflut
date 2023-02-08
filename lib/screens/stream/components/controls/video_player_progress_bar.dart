import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/stream_cubit.dart';

class VideoPlayerProgressBar extends StatelessWidget {
  final double barHeight;
  final double thumbRadius;
  final BarCapShape barCapShape;
  const VideoPlayerProgressBar(
      {super.key, this.barHeight = 6.0, this.thumbRadius = 4.5, this.barCapShape = BarCapShape.round});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: context.read<StreamCubit>().state.controller!.getPositionStream(),
      builder: (context, snapshot) => ProgressBar(
          progress: snapshot.data ?? Duration(seconds: 0),
          buffered: context.read<StreamCubit>().state.controller!.getBufferingDuration(),
          total: context.read<StreamCubit>().state.controller!.getDuration() ?? Duration(seconds: 0),
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
            context.read<StreamCubit>().state.controller!.seekTo(duration);
          }),
    );
  }
}
