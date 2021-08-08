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
  late Duration musicDuration;
  late MusicPlayer musicPlayer;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    musicDuration =
        musicPlayer.getCommonPlayer?.getDuration() ?? Duration(seconds: 0);
    // playerListener();
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
                builder: (context, musicPlayer, child) =>
                    musicPlayer.getCommonPlayer != null &&
                            musicPlayer.getCommonPlayer!.isInit()
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
                          // Expanded(
                          //     child: Text(
                          //   musicPlayer.currentMusicTitle(),
                          //   overflow: TextOverflow.ellipsis,
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(color: Colors.white),
                          // )),
                          Expanded(
                              child: StreamBuilder<Duration?>(
                                  stream: musicPlayer.getCommonPlayer!
                                      .getCurrentPosition(),
                                  builder: (context, snapshot) => Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.white12,
                                        value: getSliderSize(snapshot.data),
                                        min: 0,
                                        max: getSliderMaxSize(snapshot.data),
                                        onChanged: (value) {
                                          musicPlayer.seekTo(Duration(
                                              milliseconds: value.toInt()));
                                        },
                                      )))
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
                                  musicPlayer.getCommonPlayer!.isPlaying()
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

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null ||
        musicPlayer.getCommonPlayer?.getDuration() == null) {
      return 0;
    }
    return currentPosition.inMilliseconds.toDouble();
  }

  double getSliderMaxSize(Duration? duration) {
    if (duration == null ||
        musicPlayer.getCommonPlayer?.getDuration() == null) {
      return 0;
    }
    return musicPlayer.getCommonPlayer!.getDuration().inMilliseconds.toDouble();
  }

  // bool isInit() {
  //   if (musicPlayer.assetsAudioPlayer.current.hasValue) {
  //     return musicPlayer.assetsAudioPlayer.current.value != null ||
  //         musicPlayer.assetsAudioPlayer.isPlaying.value;
  //   }
  //   return false;
  // }
}
