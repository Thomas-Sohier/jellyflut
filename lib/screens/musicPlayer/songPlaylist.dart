import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SongPlaylist extends StatefulWidget {
  final double height;
  final Color color;
  SongPlaylist({Key key, @required this.height, @required this.color})
      : super(key: key);

  @override
  _SongPlaylistState createState() => _SongPlaylistState();
}

class _SongPlaylistState extends State<SongPlaylist> {
  MusicPlayer musicPlayer;

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
    var height = widget.height;
    return Consumer<MusicPlayer>(builder: (context, mp, child) {
      musicPlayer = mp;
      return SizedBox(
          height: height,
          child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: widget.color,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount:
                      musicPlayer.assetsAudioPlayer.playlist.numberOfItems,
                  itemBuilder: (context, index) => playlistListItem(
                      index,
                      musicPlayer
                          .assetsAudioPlayer.playlist.audios[index].metas))));
    });
  }

  Widget playlistListItem(int index, Metas metas) {
    return Dismissible(
        key: ValueKey(metas.id + Uuid().v1()),
        onDismissed: (direction) {
          musicPlayer.removePlaylistItemAtIndex(index);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: InkWell(
            onTap: () =>
                musicPlayer.assetsAudioPlayer.playlistPlayAtIndex(index),
            child: Column(
              children: [
                if (index > 0)
                  Divider(
                    color: widget.color,
                    thickness: 0.5,
                  ),
                playlistItem(index)
              ],
            ),
          ),
        ));
  }

  Widget playlistItem(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Text(
            index.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: widget.color),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                    musicPlayer
                        .assetsAudioPlayer.playlist.audios[index].metas.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.color)),
              ),
              Text(
                  musicPlayer
                      .assetsAudioPlayer.playlist.audios[index].metas.artist,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: widget.color)),
              Text(
                  musicPlayer
                      .assetsAudioPlayer.playlist.audios[index].metas.album,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: widget.color))
            ],
          ),
        )
      ],
    );
  }
}
