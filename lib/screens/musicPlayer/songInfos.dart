import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/shared/shared.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(musicPlayer.currentMusicArtist(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.color,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  musicPlayer.currentMusicTitle(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: widget.color),
                ),
              ),
            ],
          ),
          FutureBuilder<Item>(
            future: getItem(musicPlayer
                .assetsAudioPlayer.current.value.audio.audio.metas.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FavButton(
                  snapshot.data,
                  size: 42,
                  padding: EdgeInsets.all(10),
                );
              }
              return Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 42,
                ),
              );
            },
          ),
          Row(
            children: [
              Text(
                '0.00',
                style: TextStyle(color: widget.color, fontSize: 18),
              ),
              Spacer(),
              Text(
                  printDuration(Duration(
                      milliseconds:
                          musicPlayer.currentMusicMaxDuration().toInt())),
                  style: TextStyle(color: widget.color, fontSize: 18))
            ],
          )
        ],
      ),
    );
  }
}
