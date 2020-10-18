import 'package:flutter/material.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

class MusicPlayerFAB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicPlayerFABState();
}

int _playBackTime = 0;

class _MusicPlayerFABState extends State<MusicPlayerFAB> {
  @override
  void initState() {
    super.initState();
    playerListener();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayer>(
        builder: (context, musicPlayer, child) => isInit()
            ? body(musicPlayer)
            : Container(
                height: 0,
                width: 0,
              ));
  }

  Widget body(MusicPlayer musicPlayer) {
    return Container(
      width: 200,
      height: 60,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 6, color: Colors.black54, spreadRadius: 2)
      ], borderRadius: BorderRadius.circular(30), color: color1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    musicPlayer.currentMusicTitle(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
                  Expanded(
                      child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.white12,
                    value: _playBackTime.toDouble(),
                    min: 0,
                    max: musicPlayer.currentMusicMaxDuration(),
                    onChangeEnd: (value) {
                      musicPlayer.assetsAudioPlayer
                          .seek(Duration(milliseconds: value.toInt()));
                    },
                    onChanged: (value) {
                      setState(() {
                        _playBackTime = value.toInt();
                      });
                    },
                  ))
                ],
              )),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => setState(() {
                          musicPlayer.toggle();
                        }),
                        child: Icon(
                          musicPlayer.assetsAudioPlayer.isPlaying.value
                              ? Icons.pause_circle_filled_outlined
                              : Icons.play_circle_fill_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ))
                ],
              ))
        ],
      ),
    );
  }

  void playerListener() {
    MusicPlayer _musicPlayer = MusicPlayer();
    _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
      if (event.isPlaying) {
        setState(() {
          _playBackTime = event.currentPosition.inMilliseconds.toInt();
        });
      }
    });
  }
}

bool isInit() {
  MusicPlayer _musicPlayer = MusicPlayer();
  return _musicPlayer.assetsAudioPlayer.current.hasValue &&
      _musicPlayer.assetsAudioPlayer.isPlaying.value;
}
