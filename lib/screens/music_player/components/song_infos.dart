import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/fav_button/fav_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';

class SongInfos extends StatelessWidget {
  const SongInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) => Column(
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
            ));
  }
}

class SongTitleLabel extends StatelessWidget {
  const SongTitleLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final audioSource = context.read<MusicPlayerBloc>().state.currentlyPlaying;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(audioSource?.metadata.title ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class SongArtistLabel extends StatelessWidget {
  const SongArtistLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final audioSource = context.read<MusicPlayerBloc>().state.currentlyPlaying;

    if (audioSource != null && audioSource.metadata.artist.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          if (audioSource.metadata.artist.isNotEmpty) {
            await customRouter.push(DetailsRoute(item: audioSource.metadata.item, heroTag: ''));
          }
        },
        child: Text(
          audioSource.metadata.artist,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    }
    return SizedBox();
  }
}

class SongFavButton extends StatelessWidget {
  const SongFavButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioSource = context.read<MusicPlayerBloc>().state.currentlyPlaying;
    if (audioSource == null) return const SizedBox();
    return FittedBox(
      child: FavButton(
        item: audioSource.metadata.item,
        size: 36,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
