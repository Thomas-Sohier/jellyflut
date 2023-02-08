import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/music_player_bloc.dart';

class SongSlider extends StatelessWidget {
  const SongSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) => previous.currentlyPlaying.hashCode != current.currentlyPlaying.hashCode,
      builder: (context, state) => StreamBuilder<Duration?>(
          stream: state.postionStream,
          builder: (context, snapshotPosition) => AnimatedFractionallySizedBox(
              duration: Duration(seconds: 1),
              widthFactor: getSliderSize(snapshotPosition.data, state.duration),
              child: Container(color: Theme.of(context).colorScheme.secondary.withAlpha(190)))),
    );
  }

  double getSliderSize(Duration? currentPosition, Duration duration) {
    if (currentPosition == null) return 0;

    final pos = currentPosition.inMilliseconds.toDouble() / duration.inMilliseconds.toDouble();

    if (pos.isNaN || pos.isInfinite) return 0.0;
    return pos;
  }
}
