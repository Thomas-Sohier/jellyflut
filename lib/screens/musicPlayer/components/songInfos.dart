import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class SongInfos extends StatefulWidget {
  final Color color;
  SongInfos({Key? key, required this.color}) : super(key: key);

  @override
  _SongInfosState createState() => _SongInfosState();
}

class _SongInfosState extends State<SongInfos> {
  late MusicPlayer musicPlayer;

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
    return Consumer<MusicPlayer>(builder: (context, mp, child) {
      musicPlayer = mp;
      return infos();
    });
  }

  Widget infos() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (musicPlayer.getCurrentMusic?.artist != null &&
                musicPlayer.getCurrentMusic!.artist!.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  if (musicPlayer.getCurrentMusic?.artist != null) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                item: musicPlayer.getCurrentMusic!.item,
                                heroTag: '')));
                  }
                },
                child: AutoSizeText(musicPlayer.getCurrentMusic!.artist!,
                    style: TextStyle(fontSize: 20, color: widget.color),
                    maxLines: 1),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: AutoSizeText(
                musicPlayer.getCurrentMusic!.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    color: widget.color,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
        StreamBuilder<int?>(
          stream: musicPlayer.playingIndex(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FittedBox(
                child: FavButton(
                  musicPlayer.getMusicItems.elementAt(snapshot.data!).item,
                  size: 36,
                  padding: EdgeInsets.all(10),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(10),
              child: FittedBox(
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 36,
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            StreamBuilder<Duration?>(
                stream: musicPlayer.getCommonPlayer!.getCurrentPosition(),
                builder: (context, snapshot) => AutoSizeText(
                      snapshot.data != null
                          ? printDuration(snapshot.data!)
                          : '0.00',
                      style: TextStyle(fontSize: 18, color: widget.color),
                      maxLines: 1,
                    )),
            Spacer(),
            AutoSizeText(
                printDuration(musicPlayer.getCommonPlayer!.getDuration()),
                style: TextStyle(fontSize: 18, color: widget.color))
          ],
        )
      ],
    );
  }
}
