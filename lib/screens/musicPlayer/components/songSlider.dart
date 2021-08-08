import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';

class SongSlider extends StatefulWidget {
  final List<Color> albumColors;

  SongSlider({Key? key, required this.albumColors}) : super(key: key);

  @override
  _SongSliderState createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  late MusicPlayer musicPlayer;
  late Duration musicDuration;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    // playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: musicPlayer.getCommonPlayer!.getCurrentPosition(),
      builder: (context, snapshot) => FractionallySizedBox(
          widthFactor: getSliderSize(snapshot.data),
          child: Container(
            color: widget.albumColors.first.withAlpha(150),
          )),
    );
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null ||
        musicPlayer.getCommonPlayer?.getDuration() == null) {
      return 0;
    }
    return currentPosition.inMilliseconds.toDouble() /
        musicPlayer.getCommonPlayer!.getDuration().inMilliseconds.toDouble();
  }

  // void playerListener() {
  //   musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
  //     if (event.isPlaying && mounted) {
  //       setState(() {
  //         _playBackTime = event.currentPosition.inMilliseconds.toInt();
  //       });
  //     }
  //   });
  // }
}
