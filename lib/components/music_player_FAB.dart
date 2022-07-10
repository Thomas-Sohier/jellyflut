// ignore_for_file: unused_import

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/screens/music_player/music_player.dart';

class MusicPlayerFAB extends StatelessWidget {
  const MusicPlayerFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case MusicPlayerStatus.playing:
              return const MusicPlayerFABView();
            default:
              return const SizedBox();
          }
        });
  }
}

class MusicPlayerFABView extends StatelessWidget {
  const MusicPlayerFABView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  ExcludeFocus(excluding: true, child: Expanded(flex: 4, child: const CenterPart())),
                  Flexible(child: Center(child: const PlayPausebutton()))
                ],
              ),
            )));
  }
}

class PlayPausebutton extends StatelessWidget {
  const PlayPausebutton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.playingState != current.playingState,
        builder: (context, state) => InkWell(
              onTap: () => context.read<MusicPlayerBloc>().add(TogglePlayPauseRequested()),
              child: Icon(
                state.playingState == PlayingState.pause
                    ? Icons.pause_circle_filled_outlined
                    : Icons.play_circle_fill_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 28,
              ),
            ));
  }
}

class CenterPart extends StatelessWidget {
  const CenterPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.currentlyPlaying != current.currentlyPlaying,
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  state.currentlyPlaying?.metadata.title ?? '',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                )),
                Expanded(
                    child: StreamBuilder<Duration?>(
                        stream: state.postionStream,
                        builder: (context, snapshot) => Slider(
                              activeColor: Theme.of(context).colorScheme.onPrimary,
                              inactiveColor: Theme.of(context).colorScheme.onPrimary.withAlpha(32),
                              value: getSliderSize(snapshot.data),
                              min: 0.0,
                              max: getSliderMaxSize(state.duration, snapshot.data),
                              onChanged: (value) {
                                context
                                    .read<MusicPlayerBloc>()
                                    .add(SeekRequested(position: Duration(milliseconds: value.toInt())));
                              },
                            )))
              ],
            ));
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
    return duration.inMilliseconds.toDouble();
  }
}
