// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/musicPlayer.dart'
    as music_player_widget;
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

class MusicPlayerFAB extends StatefulWidget {
  final Widget child;

  const MusicPlayerFAB({required this.child});

  @override
  State<StatefulWidget> createState() => _MusicPlayerFABState();
}

class _MusicPlayerFABState extends State<MusicPlayerFAB> {
  late int _playBackTime;
  late MusicPlayer musicPlayer;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    if (musicPlayer.assetsAudioPlayer.current.hasValue) {
      _playBackTime = musicPlayer
          .assetsAudioPlayer.current.value!.audio.duration.inMilliseconds;
    } else {
      _playBackTime = 0;
    }
    playerListener();
  }

  @override
  void dispose() {
    // musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
            bottom: 15,
            right: 15,
            child: Consumer<MusicPlayer>(
                builder: (context, musicPlayer, child) => isInit()
                    ? body(musicPlayer)
                    : Container(
                        height: 0,
                        width: 0,
                      )))
      ],
    );
  }

  Widget body(MusicPlayer musicPlayer) {
    return Hero(
        tag: 'musicPlayerFAB',
        child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 60,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 6, color: Colors.black54, spreadRadius: 2)
              ], borderRadius: BorderRadius.circular(30), color: jellyPurple),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              music_player_widget.MusicPlayer(),
                        )),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                      flex: 4,
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
                                  max: musicPlayer.currentMusicMaxDuration() <=
                                          _playBackTime.toDouble()
                                      ? _playBackTime.toDouble() + 1
                                      : musicPlayer.currentMusicMaxDuration(),
                                  onChangeEnd: (value) {
                                    musicPlayer.assetsAudioPlayer.seek(
                                        Duration(milliseconds: value.toInt()));
                                  },
                                  onChanged: (value) =>
                                      _playBackTime = value.toInt()))
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
                                onTap: () => musicPlayer.toggle(),
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
            )));
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

  bool isInit() {
    if (musicPlayer.assetsAudioPlayer != null &&
        musicPlayer.assetsAudioPlayer.current.hasValue) {
      return musicPlayer.assetsAudioPlayer.current.value != null ||
          musicPlayer.assetsAudioPlayer.isPlaying.value;
    }
    return false;
  }
}
