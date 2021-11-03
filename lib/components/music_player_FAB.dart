// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/screens/musicPlayer/music_player.dart';
import 'package:jellyflut/theme.dart';
import 'package:provider/provider.dart';

class MusicPlayerFAB extends StatefulWidget {
  final Widget child;
  final double positionBottom;
  final double positionLeft;
  final double positionRight;
  final double positionTop;

  const MusicPlayerFAB(
      {required this.child,
      this.positionBottom = 15,
      this.positionLeft = 0,
      this.positionRight = 15,
      this.positionTop = 0});

  @override
  State<StatefulWidget> createState() => _MusicPlayerFABState();
}

class _MusicPlayerFABState extends State<MusicPlayerFAB> {
  late final Duration musicDuration;
  late final MusicProvider musicPlayer;
  AudioMetadata? audioMetadata;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicProvider();
    musicDuration = musicPlayer.getDuration();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
            bottom: widget.positionBottom,
            right: widget.positionRight,
            child: Consumer<MusicProvider>(
                builder: (context, musicPlayer, child) => isInit()
                    ? body(musicPlayer)
                    : Container(
                        height: 0,
                        width: 0,
                      )))
      ],
    );
  }

  Widget body(MusicProvider musicPlayer) {
    if (musicPlayer.getCurrentMusic() != null) {
      audioMetadata = musicPlayer.getCurrentMusic()?.tag;
    }
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
                    onTap: () => customRouter.push(MusicPlayerRoute()),
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
                            audioMetadata?.title ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                          Expanded(
                              child: StreamBuilder<Duration?>(
                                  stream: musicPlayer.getPositionStream(),
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
                      child: Center(
                          child: StreamBuilder<bool>(
                        stream: musicPlayer.isPlaying(),
                        builder: (context, snapshot) => InkWell(
                          onTap: () => isPlaying(snapshot.data)
                              ? musicPlayer.pause()
                              : musicPlayer.play(),
                          child: Icon(
                            isPlaying(snapshot.data)
                                ? Icons.pause_circle_filled_outlined
                                : Icons.play_circle_fill_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      )))
                ],
              ),
            )));
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null) return 0;
    return currentPosition.inMilliseconds.toDouble();
  }

  double getSliderMaxSize(Duration? duration) {
    if (duration == null) return 0;
    return musicPlayer.getDuration().inMilliseconds.toDouble();
  }

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }

  bool isInit() {
    return musicPlayer.getAudioPlayer != null;
  }
}
