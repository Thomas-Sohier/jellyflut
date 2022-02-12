// ignore_for_file: unused_import

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/screens/musicPlayer/music_player.dart';
import 'package:provider/provider.dart';

class MusicPlayerFAB extends StatefulWidget {
  const MusicPlayerFAB();

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
    return Consumer<MusicProvider>(
        builder: (context, musicPlayer, child) =>
            isInit() ? body(musicPlayer) : const SizedBox());
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
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4, color: Colors.black38, spreadRadius: 2)
                  ],
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => customRouter.push(MusicPlayerRoute()),
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          )),
                          Expanded(
                              child: StreamBuilder<Duration?>(
                                  stream: musicPlayer.getPositionStream(),
                                  builder: (context, snapshot) => Slider(
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        inactiveColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withAlpha(32),
                                        value: getSliderSize(snapshot.data),
                                        min: 0.0,
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
                            color: Theme.of(context).colorScheme.onPrimary,
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
