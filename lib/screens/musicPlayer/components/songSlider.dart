import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/music/musicProvider.dart';

class SongSlider extends StatefulWidget {
  final List<Color> albumColors;

  SongSlider({Key? key, required this.albumColors}) : super(key: key);

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
    // playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: musicProvider.getCommonPlayer!.getCurrentPosition(),
      builder: (context, snapshot) => FractionallySizedBox(
          widthFactor: getSliderSize(snapshot.data),
          child: Container(
            color: widget.albumColors.first.withAlpha(150),
          )),
    );
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null ||
        musicProvider.getCommonPlayer?.getDuration() == null) {
      return 0;
    }
    return currentPosition.inMilliseconds.toDouble() /
        musicProvider.getCommonPlayer!.getDuration().inMilliseconds.toDouble();
  }
}
