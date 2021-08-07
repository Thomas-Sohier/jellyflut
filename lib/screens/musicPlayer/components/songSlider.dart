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
  late int _playBackTime;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    _playBackTime = musicPlayer.currentMusicDuration().toInt();
    playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sliderSize = _playBackTime / musicPlayer.currentMusicMaxDuration();
    return FractionallySizedBox(
        widthFactor: sliderSize < 0 ? 0 : sliderSize,
        child: Container(
          color: widget.albumColors[1].withAlpha(150),
        ));
  }

  void playerListener() {
    musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
      if (event.isPlaying && mounted) {
        setState(() {
          _playBackTime = event.currentPosition.inMilliseconds.toInt();
        });
      }
    });
  }
}
