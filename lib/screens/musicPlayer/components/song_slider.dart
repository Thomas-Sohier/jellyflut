import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';

class SongSlider extends StatefulWidget {
  final List<Color> albumColors;

  SongSlider({super.key, required this.albumColors});

  @override
  _SongSliderState createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  late MusicProvider musicProvider;
  late Duration musicDuration;

  @override
  void initState() {
    super.initState();
    musicProvider = MusicProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioColors>(
        stream: musicProvider.getColorcontroller,
        initialData: AudioColors(),
        builder: (context, snapshotColor) => StreamBuilder<Duration?>(
              stream: musicProvider.getPositionStream(),
              builder: (context, snapshotPosition) => FractionallySizedBox(
                  widthFactor: getSliderSize(snapshotPosition.data),
                  child: Container(
                    color: snapshotColor.data!.backgroundColor1.withAlpha(150),
                  )),
            ));
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null) return 0;

    final pos = currentPosition.inMilliseconds.toDouble() /
        musicProvider.getDuration().inMilliseconds.toDouble();

    if (pos.isNaN) return 0.0;
    return pos;
  }
}
