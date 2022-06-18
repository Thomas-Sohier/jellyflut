import 'package:animated_fractionally_sized_box/animated_fractionally_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/music/music_provider.dart';

class SongSlider extends StatefulWidget {
  const SongSlider({super.key});

  @override
  State<SongSlider> createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  late MusicProvider musicProvider;
  late Duration musicDuration;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    musicProvider = MusicProvider();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: musicProvider.getPositionStream(),
      builder: (context, snapshotPosition) => AnimatedFractionallySizedBox(
          duration: Duration(seconds: 1),
          widthFactor: getSliderSize(snapshotPosition.data),
          child: Container(color: theme.colorScheme.secondary.withAlpha(190))),
    );
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null) return 0;

    final pos = currentPosition.inMilliseconds.toDouble() /
        musicProvider.getDuration().inMilliseconds.toDouble();

    if (pos.isNaN || pos.isInfinite) return 0.0;
    return pos;
  }
}
