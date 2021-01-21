import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';

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
    musicPlayer = MusicPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = widget.height;
    return SizedBox(
        height: height,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: musicPlayer.assetsAudioPlayer.playlist.numberOfItems,
            itemBuilder: (context, index) => playlistItem(index,
                musicPlayer.assetsAudioPlayer.playlist.audios[index].metas)));
  }

  Widget playlistItem(int index, Metas metas) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: InkWell(
          onTap: () => musicPlayer.assetsAudioPlayer.playlistPlayAtIndex(index),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: widget.color, width: 0.5)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.color),
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
                            musicPlayer.assetsAudioPlayer.playlist.audios[index]
                                .metas.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: widget.color)),
                      ),
                      Text(
                          musicPlayer.assetsAudioPlayer.playlist.audios[index]
                              .metas.artist,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: widget.color)),
                      Text(
                          musicPlayer.assetsAudioPlayer.playlist.audios[index]
                              .metas.album,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: widget.color))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
