import 'package:flutter/material.dart';
import 'package:jellyflut/components/fav_button/fav_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/music_player/models/audio_metadata.dart';
import 'package:jellyflut/screens/music_player/models/audio_source.dart';
import 'package:provider/provider.dart';

class SongInfos extends StatefulWidget {
  const SongInfos({super.key});

  @override
  State<SongInfos> createState() => _SongInfosState();
}

class _SongInfosState extends State<SongInfos> {
  late MusicProvider musicProvider;
  AudioMetadata? audioMetadata;

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, mp, child) {
      musicProvider = mp;
      setAudioMetadata();
      return infos();
    });
  }

  Widget infos() {
    return StreamBuilder<AudioSource>(
        stream: musicProvider.getCurrentMusicStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final metadata = snapshot.data!.metadata;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [songTitleLabel(metadata), songArtistLabel(metadata)],
                ),
                songFavButton(metadata)
              ],
            );
          }
          return SizedBox();
        });
  }

  Widget songTitleLabel(AudioMetadata metadata) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(metadata.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget songArtistLabel(AudioMetadata metadata) {
    if (metadata.artist.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          if (metadata.artist.isNotEmpty) {
            await customRouter.push(DetailsRoute(item: audioMetadata!.item, heroTag: ''));
          }
        },
        child: Text(
          metadata.artist,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    }
    return SizedBox();
  }

  Widget songFavButton(AudioMetadata metadata) {
    return FittedBox(
      child: FavButton(
        item: metadata.item,
        size: 36,
        padding: EdgeInsets.all(10),
      ),
    );
  }

  void setAudioMetadata() {
    final currentMusic = musicProvider.getCurrentMusic();
    if (currentMusic != null) {
      audioMetadata = currentMusic.metadata;
    }
  }
}
