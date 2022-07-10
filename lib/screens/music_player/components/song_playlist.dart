import 'package:flutter/material.dart';
import 'package:music_player_api/music_player_api.dart';
import 'package:provider/provider.dart';

import '../bloc/music_player_bloc.dart';

class SongPlaylist extends StatelessWidget {
  const SongPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerbloc = context.read<MusicPlayerBloc>();
    return ClipRect(
      child: ReorderableListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: musicPlayerbloc.state.playlist.length,
        itemBuilder: (context, index) => PlaylistListItem(
            key: ValueKey(musicPlayerbloc.state.playlist[index]),
            index: index,
            audioSource: musicPlayerbloc.state.playlist[index]),
        onReorder: (int oldIndex, int newIndex) =>
            musicPlayerbloc.add(ReoderList(oldIndex: oldIndex, newIndex: newIndex)),
      ),
    );
  }
}

class PlaylistListItem extends StatelessWidget {
  final AudioSource audioSource;
  final int index;
  const PlaylistListItem({super.key, required this.index, required this.audioSource});

  @override
  Widget build(BuildContext context) {
    final musicPlayerbloc = context.read<MusicPlayerBloc>();
    return Dismissible(
      key: ValueKey(musicPlayerbloc.state.playlist[index]),
      onDismissed: (_) => musicPlayerbloc.add(DeleteAudioFromPlaylist(index: index)),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 48),
        color: Theme.of(context).colorScheme.error,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
              Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.onError),
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
              onTap: () => musicPlayerbloc.add(PlayAtIndex(index: index)),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: PlaylistItem(index: index, audioSource: audioSource)))
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final AudioSource audioSource;
  final int index;
  const PlaylistItem({super.key, required this.index, required this.audioSource});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Text(
            index.toString(),
            style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(audioSource.metadata.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Text(audioSource.metadata.artist,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14)),
              if (audioSource.metadata.album != null)
                Text(audioSource.metadata.album!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14))
            ],
          ),
        )
      ],
    );
  }
}
