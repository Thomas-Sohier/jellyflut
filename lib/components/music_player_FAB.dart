// ignore_for_file: unused_import

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/music_player/models/audio_metadata.dart';
import 'package:jellyflut/screens/music_player/music_player.dart';
import 'package:provider/provider.dart';

class MusicPlayerFAB extends StatefulWidget {
  const MusicPlayerFAB();

  @override
  State<StatefulWidget> createState() => _MusicPlayerFABState();
}

class _MusicPlayerFABState extends State<MusicPlayerFAB> {
  late final Duration musicDuration;
  late MusicProvider musicPlayer;
  AudioMetadata? audioMetadata;

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, musicProvider, child) {
      musicPlayer = musicProvider;
      return musicPlayer.isInit ? body(musicPlayer) : const SizedBox();
    });
  }

  Widget body(MusicProvider musicPlayer) {
    if (musicPlayer.getCurrentMusic() != null) {
      audioMetadata = musicPlayer.getCurrentMusic()?.metadata;
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
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black38, spreadRadius: 2)],
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
                  ExcludeFocus(excluding: true, child: Expanded(flex: 4, child: centerPart())),
                  Flexible(child: Center(child: playPauseButton()))
                ],
              ),
            )));
  }

  Widget playPauseButton() {
    return StreamBuilder<bool?>(
      stream: musicPlayer.isPlaying(),
      builder: (context, snapshot) => InkWell(
        onTap: () => isPlaying(snapshot.data) ? musicPlayer.pause() : musicPlayer.play(),
        child: Icon(
          isPlaying(snapshot.data) ? Icons.pause_circle_filled_outlined : Icons.play_circle_fill_outlined,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }

  Widget centerPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          audioMetadata?.title ?? '',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        )),
        Expanded(
            child: StreamBuilder<Duration?>(
                stream: musicPlayer.getPositionStream(),
                builder: (context, snapshot) => Slider(
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      inactiveColor: Theme.of(context).colorScheme.onPrimary.withAlpha(32),
                      value: getSliderSize(snapshot.data),
                      min: 0.0,
                      max: getSliderMaxSize(musicPlayer.getDuration(), snapshot.data),
                      onChanged: (value) {
                        musicPlayer.seekTo(Duration(milliseconds: value.toInt()));
                      },
                    )))
      ],
    );
  }

  double getSliderSize(Duration? currentPosition) {
    if (currentPosition == null) return 0;
    return currentPosition.inMilliseconds.toDouble();
  }

  double getSliderMaxSize(Duration? duration, Duration? currentPosition) {
    if (duration == null || currentPosition == null) return 0;
    if (currentPosition > duration) {
      return currentPosition.inMilliseconds.toDouble();
    }
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
