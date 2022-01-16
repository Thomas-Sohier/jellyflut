import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class SongPlaylist extends StatefulWidget {
  SongPlaylist({Key? key}) : super(key: key);

  @override
  _SongPlaylistState createState() => _SongPlaylistState();
}

class _SongPlaylistState extends State<SongPlaylist> {
  late MusicProvider musicProvider;

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
      return GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Theme.of(context).colorScheme.primary,
          child: ChangeNotifierProvider.value(
            value: musicProvider,
            child: ReorderableListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: musicProvider.getPlayList().length,
              itemBuilder: (context, index) =>
                  playlistListItem(index, musicProvider.getPlayList()[index]),
              onReorder: (int oldIndex, int newIndex) =>
                  musicProvider.moveMusicItem(oldIndex, newIndex),
            ),
          ));
    });
  }

  Widget playlistListItem(int index, IndexedAudioSource musicItem) {
    return Dismissible(
      key: ValueKey(musicItem),
      onDismissed: (direction) {
        musicProvider.deleteFromPlaylist(index);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 48),
        color: Colors.red,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ]),
      ),
      dismissThresholds: {DismissDirection.horizontal: 0.3},
      child: Column(
        children: [
          if (index > 0)
            Divider(
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
              height: 0.5,
              thickness: 0.5,
            ),
          InkWell(
              onTap: () => musicProvider.playAtIndex(index),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: playlistItem(index, musicItem)))
        ],
      ),
    );
  }

  Widget playlistItem(int index, IndexedAudioSource musicItem) {
    final metadata = musicItem.tag as AudioMetadata;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Text(
            index.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(metadata.title,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Text(metadata.artist,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              if (metadata.album != null)
                Text(metadata.album!,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal))
            ],
          ),
        )
      ],
    );
  }
}
