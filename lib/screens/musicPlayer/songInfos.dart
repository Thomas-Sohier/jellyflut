import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';

class SongInfos extends StatefulWidget {
  final double height;
  final Color color;
  SongInfos({Key key, @required this.height, @required this.color})
      : super(key: key);

  @override
  _SongInfosState createState() => _SongInfosState();
}

class _SongInfosState extends State<SongInfos> {
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
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                musicPlayer.currentMusicTitle(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: widget.color),
              ),
              Text(musicPlayer.currentMusicArtist(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 18,
                      color: widget.color,
                      fontWeight: FontWeight.w300))
            ],
          ),
        ));
  }
}
