// ignore_for_file: unused_import

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
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
        child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            buildWhen: (previous, current) => previous.theme != current.theme,
            builder: (context, state) => Theme(data: state.theme, child: FabButtonBody())));
  }
}

class FabButtonBody extends StatelessWidget {
  static const double maxWidth = 250;
  static const double maxHeight = 60;

  const FabButtonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 8, color: Theme.of(context).colorScheme.primary.withAlpha(120), spreadRadius: 2)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
            child: Stack(
              children: [
                BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                    buildWhen: (previous, current) => previous.playingState != current.playingState,
                    builder: (context, state) {
                      if (state.currentlyPlaying != null) {
                        return Align(
                            alignment: Alignment.centerRight,
                            child: Image.memory(
                              state.currentlyPlaying!.metadata.artworkByte,
                              alignment: Alignment.center,
                              width: maxWidth * 0.3, // 30% of width to prevent blank space with gradient
                              height: maxHeight,
                              fit: BoxFit.cover,
                            ));
                      }
                      return const SizedBox();
                    }),
                SizedBox.expand(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withAlpha(160),
                      Theme.of(context).colorScheme.primary.withAlpha(80)
                    ], stops: [
                      0.7,
                      0.8,
                      1
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => context.router.root.push(r.MusicPlayerPage()),
                        iconSize: 28,
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const ExcludeFocus(excluding: true, child: Expanded(child: CenterPart())),
                      const SizedBox(width: 8),
                      const PlayPausebutton(),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayPausebutton extends StatelessWidget {
  const PlayPausebutton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.playingState != current.playingState,
        builder: (context, state) => IconButton(
              onPressed: () => context.read<MusicPlayerBloc>().add(TogglePlayPauseRequested()),
              iconSize: 28,
              icon: Icon(
                state.playingState == PlayingState.pause
                    ? Icons.play_circle_fill_outlined
                    : Icons.pause_circle_filled_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
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
                      Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
