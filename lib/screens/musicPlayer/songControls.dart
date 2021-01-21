import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';

class SongControls extends StatefulWidget {
  final double height;
  final Color color;
  SongControls({Key key, @required this.height, @required this.color})
      : super(key: key);

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  MusicPlayer musicPlayer;
  int _playBackTime;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    _playBackTime = musicPlayer.assetsAudioPlayer?.current?.value?.audio
            ?.duration?.inMilliseconds ??
        0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = widget.height;
    return Container(
        height: height,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => musicPlayer.assetsAudioPlayer.previous(),
                child: Icon(
                  Icons.skip_previous,
                  color: widget.color,
                  size: 48,
                ),
              ),
              InkWell(
                onTap: () => musicPlayer.toggle(),
                child: Icon(
                  musicPlayer.assetsAudioPlayer.isPlaying.value
                      ? Icons.pause_circle_filled_outlined
                      : Icons.play_circle_fill_outlined,
                  color: widget.color,
                  size: 48,
                ),
              ),
              InkWell(
                onTap: () => musicPlayer.assetsAudioPlayer.next(),
                child: Icon(
                  Icons.skip_next,
                  color: widget.color,
                  size: 48,
                ),
              ),
            ],
          ),
          Expanded(
              child: Slider(
                  activeColor: widget.color,
                  inactiveColor: widget.color.withAlpha(100),
                  value: _playBackTime.toDouble(),
                  min: 0,
                  max: musicPlayer.currentMusicMaxDuration() <=
                          _playBackTime.toDouble()
                      ? _playBackTime.toDouble() + 1
                      : musicPlayer.currentMusicMaxDuration(),
                  onChangeEnd: (value) {
                    musicPlayer.assetsAudioPlayer
                        .seek(Duration(milliseconds: value.toInt()));
                  },
                  onChanged: (value) => _playBackTime = value.toInt()))
        ]));
  }
}
