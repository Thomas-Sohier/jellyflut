import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SongPlaylist extends StatefulWidget {
  final Color backgroundColor;
  final Color color;
  SongPlaylist({Key? key, required this.backgroundColor, required this.color})
      : super(key: key);

  @override
  _SongPlaylistState createState() => _SongPlaylistState();
}

class _SongPlaylistState extends State<SongPlaylist> {
  late MusicPlayer musicPlayer;
  final ThemeData settingsThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: jellyPurple,
  );

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
    return Theme(
        data: settingsThemeData,
        child: Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: AppBar(
              title: Text('Playlist'),
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              backgroundColor: widget.backgroundColor,
            ),
            body: Consumer<MusicPlayer>(builder: (context, mp, child) {
              musicPlayer = mp;
              return GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: widget.color,
                  child: ChangeNotifierProvider.value(
                      value: musicPlayer,
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: musicPlayer.getPlayList().length,
                        itemBuilder: (context, index) => playlistListItem(
                            index, musicPlayer.getPlayList()[index]),
                        onReorder: (int oldIndex, int newIndex) =>
                            musicPlayer.moveMusicItem(oldIndex, newIndex),
                      )));
            })));
  }

  Widget playlistListItem(int index, MusicItem musicItem) {
    return Dismissible(
      key: ValueKey(musicItem.id.toString() + Uuid().v1()),
      onDismissed: (direction) {
        musicPlayer.deleteFromPlaylist(index);
      },
      background: Container(
        color: Colors.red,
      ),
      dismissThresholds: {DismissDirection.horizontal: 0.3},
      child: Column(
        children: [
          if (index > 0)
            Divider(
              color: widget.color.withAlpha(100),
              height: 0.5,
              thickness: 0.5,
            ),
          InkWell(
              onTap: () => musicPlayer.playAtIndex(index),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: playlistItem(index, musicItem)))
        ],
      ),
    );
  }

  Widget playlistItem(int index, MusicItem musicItem) {
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
                child: Text(musicItem.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.color)),
              ),
              if (musicItem.artist != null)
                Text(musicItem.artist!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: widget.color)),
              if (musicItem.album != null)
                Text(musicItem.album!,
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
