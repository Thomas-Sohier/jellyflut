import 'package:flutter/material.dart';

import 'package:jellyflut/components/fav_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class SongInfos extends StatefulWidget {
  final Color color;
  SongInfos({super.key, required this.color});

  @override
  _SongInfosState createState() => _SongInfosState();
}

class _SongInfosState extends State<SongInfos> {
  late MusicProvider musicProvider;
  AudioMetadata? audioMetadata;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, mp, child) {
      musicProvider = mp;
      setAudioMetadata();
      return infos();
    });
  }

  Widget infos() {
    return StreamBuilder<SequenceState?>(
        stream: musicProvider.getCurrentMusicStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // If we have no metadata we show enty box
            if (snapshot.data!.currentSource?.tag == null) {
              return const SizedBox();
            }

            final metadata = snapshot.data!.currentSource?.tag as AudioMetadata;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    songArtistLabel(metadata),
                    songTitleLabel(metadata)
                  ],
                ),
                songFavButton(metadata),
                songDurationAndPosition()
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
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget songArtistLabel(AudioMetadata metadata) {
    if (metadata.artist.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          if (metadata.artist.isNotEmpty) {
            await customRouter
                .push(DetailsRoute(item: audioMetadata!.item, heroTag: ''));
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

  Widget songDurationAndPosition() {
    return Row(
      children: [
        StreamBuilder<Duration?>(
            stream: musicProvider.getPositionStream(),
            builder: (context, snapshot) => Text(
                  snapshot.data != null
                      ? printDuration(snapshot.data!)
                      : '0.00',
                  style: Theme.of(context).textTheme.bodyText1,
                )),
        Spacer(),
        Text(printDuration(musicProvider.getDuration()),
            style: Theme.of(context).textTheme.bodyText1)
      ],
    );
  }

  Widget songFavButton(AudioMetadata metadata) {
    return FittedBox(
      child: FavButton(
        metadata.item,
        size: 36,
        padding: EdgeInsets.all(10),
      ),
    );
  }

  void setAudioMetadata() {
    final currentMusic = musicProvider.getCurrentMusic();
    if (currentMusic != null) {
      audioMetadata = currentMusic.tag as AudioMetadata;
    }
  }
}
