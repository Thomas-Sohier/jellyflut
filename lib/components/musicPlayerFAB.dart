// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/musicProvider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/musicPlayer.dart';
import 'package:jellyflut/shared/theme.dart';
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

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicProvider();
    musicDuration =
        musicPlayer.getCommonPlayer?.getDuration() ?? Duration(seconds: 0);
    if (musicPlayer.getCommonPlayer != null) {
      musicPlayer.getCommonPlayer!
          .listenPlayingindex()
          .listen((event) => setState(() {
                musicPlayer.setPlayingIndex(event);
              }));
    }
    // musicPlayerIn
    // playerListener();
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
                            musicPlayer.getCurrentMusic?.title ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
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
                      child: Center(
                          child: StreamBuilder<bool>(
                        stream: musicPlayer.getCommonPlayer!.isPlaying(),
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

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }

  bool isInit() {
    if (musicPlayer.getCommonPlayer != null) {
      return musicPlayer.getCommonPlayer!.isInit();
    }
    return false;
  }
}
