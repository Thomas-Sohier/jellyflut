import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
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
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) => previous.theme != current.theme,
      builder: (context, state) => Scaffold(
          body: Theme(
              data: state.theme,
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 960 && musicPlayerBloc.state.screenLayout == ScreenLayout.mobile) {
                  musicPlayerBloc.add(LayoutChanged(screenLayout: ScreenLayout.desktop));
                } else if (constraints.maxWidth < 960 && musicPlayerBloc.state.screenLayout == ScreenLayout.desktop) {
                  musicPlayerBloc.add(LayoutChanged(screenLayout: ScreenLayout.mobile));
                }

                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(child: SongDetails()),
                      if (constraints.maxWidth > 960) const Expanded(child: SongPlaylistCard(child: SongPlaylist()))
                    ]);
              }))),
    );
  }
}

class SongDetails extends StatelessWidget {
  const SongDetails({super.key});

  @override
  Widget build(BuildContext context) {
    const controlsOverflowSize = 30.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
      BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          buildWhen: (previous, current) => previous.screenLayout != current.screenLayout,
          builder: (context, state) => AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              actions: [if (state.screenLayout == ScreenLayout.mobile) playlistButton(context)])),
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

  Widget playlistButton(BuildContext context) {
    return IconButton(
        onPressed: () => context.router.root.push(r.PlaylistPage(body: const SongPlaylist())),
        icon: const Icon(Icons.album));
  }
}
