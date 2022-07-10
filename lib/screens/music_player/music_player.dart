import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/screens/music_player/components/song_infos.dart';
import 'package:jellyflut/screens/music_player/components/song_playlist.dart';

import 'components/song_controls.dart';
import 'components/song_duration_position.dart';
import 'components/song_image.dart';
import 'components/song_playlist_card.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return Scaffold(
        body: Theme(
            data: musicPlayerBloc.state.theme,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 960) {
                musicPlayerBloc.add(LayoutChanged(screenLayout: ScreenLayout.desktop));
              } else {
                musicPlayerBloc.add(LayoutChanged(screenLayout: ScreenLayout.mobile));
              }
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: const SongDetails()),
                    if (constraints.maxWidth > 960) Expanded(child: const SongPlaylistCard(child: SongPlaylist()))
                  ]);
            })));
  }
}

class SongDetails extends StatelessWidget {
  const SongDetails({super.key});

  @override
  Widget build(BuildContext context) {
    const controlsOverflowSize = 30.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
      AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [if (context.read<MusicPlayerBloc>().state.screenLayout == ScreenLayout.mobile) playlistButton()]),
      const SizedBox(height: 10),
      const SongInfos(),
      const SizedBox(height: 20),
      Expanded(child: LayoutBuilder(builder: (context, constraints) {
        final singleSize = calculateSingleSize(constraints);
        return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: singleSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SongDurationPosition(),
                Stack(alignment: Alignment.topCenter, children: [
                  Column(
                    children: const [SongImage(), SizedBox(height: controlsOverflowSize)],
                  ),
                  const Positioned(bottom: 0, child: SongControls())
                ]),
              ],
            ));
      })),
    ]);
  }

  double calculateSingleSize(BoxConstraints constraints) {
    final smallestSide = min(constraints.maxWidth, constraints.maxHeight);
    return (smallestSide * 0.90 > 600 ? 600 : smallestSide * 0.90) * 0.9;
  }

  Widget playlistButton() {
    return IconButton(
        onPressed: () => customRouter.push(PlaylistRoute(body: const SongPlaylist())), icon: const Icon(Icons.album));
  }
}
