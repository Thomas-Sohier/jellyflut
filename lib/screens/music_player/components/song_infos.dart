import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/fav_button/fav_button.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';

class SongInfos extends StatelessWidget {
  const SongInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [SongTitleLabel(), SongArtistLabel()],
        ),
        const SongFavButton()
      ],
    );
  }
}

class SongTitleLabel extends StatelessWidget {
  const SongTitleLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          buildWhen: (previous, current) => previous.currentlyPlaying.hashCode != current.currentlyPlaying.hashCode,
          builder: (context, state) => Text(state.currentlyPlaying?.metadata.title ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ));
  }
}

class SongArtistLabel extends StatelessWidget {
  const SongArtistLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.currentlyPlaying.hashCode != current.currentlyPlaying.hashCode,
        builder: (context, state) {
          final audioSource = state.currentlyPlaying;

          if (audioSource != null && audioSource.metadata.artist.isNotEmpty) {
            return GestureDetector(
              onTap: () async {
                if (audioSource.metadata.artist.isNotEmpty) {
                  await context.router.root.push(r.DetailsPage(item: audioSource.metadata.item, heroTag: ''));
                }
              },
              child: Text(
                audioSource.metadata.artist,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return SizedBox();
        });
  }
}

class SongFavButton extends StatelessWidget {
  const SongFavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.currentlyPlaying.hashCode != current.currentlyPlaying.hashCode,
        builder: (context, state) {
          if (state.currentlyPlaying != null) {
            return FavButton(
              item: state.currentlyPlaying!.metadata.item,
              size: 36,
              padding: const EdgeInsets.all(10),
            );
          }
          return const SizedBox();
        });
  }
}
