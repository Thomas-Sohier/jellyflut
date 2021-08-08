import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/details/itemDialogActions.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class SongInfos extends StatefulWidget {
  final double height;
  final Color color;
  SongInfos({Key? key, required this.height, required this.color})
      : super(key: key);

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
              if (musicPlayer.getCurrentMusic?.artist != null)
                GestureDetector(
                  // onTap: () async {
                  //   if (musicPlayer.getCurrentMusic?.artist != null) {
                  //     await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 Details(item: musicPlayer.getCurrentMusic, heroTag: '')));
                  //   }
                  // },
                  child: Text(musicPlayer.getCurrentMusic!.artist!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.color,
                      )),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  musicPlayer.getCurrentMusic!.title,
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
          // FutureBuilder<Item>(
          //   future: getItem(musicPlayer.getCurrentMusic!.id),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return FavButton(
          //         snapshot.data!,
          //         size: 42,
          //         padding: EdgeInsets.all(10),
          //       );
          //     }
          //     return Padding(
          //       padding: EdgeInsets.all(10),
          //       child: Icon(
          //         Icons.favorite_border,
          //         color: Colors.red,
          //         size: 42,
          //       ),
          //     );
          //   },
          // ),
          Row(
            children: [
              StreamBuilder<Duration?>(
                  stream: musicPlayer.getCommonPlayer!.getCurrentPosition(),
                  builder: (context, snapshot) => Text(
                        snapshot.data != null
                            ? printDuration(snapshot.data!)
                            : '0.00',
                        style: TextStyle(color: widget.color, fontSize: 18),
                      )),
              Spacer(),
              Text(printDuration(musicPlayer.getCommonPlayer!.getDuration()),
                  style: TextStyle(color: widget.color, fontSize: 18))
            ],
          )
        ],
      ),
    );
  }
}
