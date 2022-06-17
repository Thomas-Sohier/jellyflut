import 'dart:ui';

import 'package:animated_fractionally_sized_box/animated_fractionally_sized_box.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';

class SongSlider extends StatefulWidget {
  SongSlider({Key? key}) : super(key: key);

  @override
  _SongSliderState createState() => _SongSliderState();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: musicProvider.getPositionStream(),
      builder: (context, snapshotPosition) => AnimatedFractionallySizedBox(
          duration: Duration(seconds: 1),
          widthFactor: getSliderSize(snapshotPosition.data),
          child: Container(color: theme.colorScheme.secondary.withAlpha(150))),
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
