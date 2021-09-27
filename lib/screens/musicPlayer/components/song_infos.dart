import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/fav_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class SongInfos extends StatefulWidget {
  final Color color;
  SongInfos({Key? key, required this.color}) : super(key: key);

  @override
  _SongInfosState createState() => _SongInfosState();
}

class _SongInfosState extends State<SongInfos> {
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
            if (musicProvider.getCurrentMusic?.artist != null &&
                musicProvider.getCurrentMusic!.artist!.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  if (musicProvider.getCurrentMusic?.artist != null) {
                    await customRouter.push(DetailsRoute(
                        item: musicProvider.getCurrentMusic!.item,
                        heroTag: ''));
                  }
                },
                child: Text(
                  musicProvider.getCurrentMusic!.artist!,
                  style: TextStyle(fontSize: 20, color: widget.color),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                musicProvider.getCurrentMusic!.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    color: widget.color,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        StreamBuilder<int?>(
          stream: musicProvider.playingIndex(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FittedBox(
                child: FavButton(
                  musicProvider.getMusicItems.elementAt(snapshot.data!).item,
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
                stream: musicProvider.getCommonPlayer!.getCurrentPosition(),
                builder: (context, snapshot) => Text(
                      snapshot.data != null
                          ? printDuration(snapshot.data!)
                          : '0.00',
                      style: TextStyle(fontSize: 18, color: widget.color),
                    )),
            Spacer(),
            Text(printDuration(musicProvider.getCommonPlayer!.getDuration()),
                style: TextStyle(fontSize: 18, color: widget.color))
          ],
        )
      ],
    );
  }
}
