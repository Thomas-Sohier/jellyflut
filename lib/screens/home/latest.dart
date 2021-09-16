import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class Latest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LatestState();
  }
}

const double gapSize = 20;
const double listViewHeight = 200;

class _LatestState extends State<Latest> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: Text(
          'latest',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ).tr(),
      ),
      // SizedBox(
      //     height: 220.0,
      //     child: FutureBuilder(
      //       future: getMediaResume(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           List<Widget> _latestMedia = displayLatestMedia(snapshot.data);
      //           return ListView(
      //             shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             children: _latestMedia,
      //           );
      //         } else if (snapshot.hasError) {
      //           // handle error.
      //           return Container(child: Text("Error"));
      //         } else {
      //           return ListView(
      //             children: [],
      //           );
      //         }
      //       },
      //     ))
    ]);
  }

  List<Widget> displayLatestMedia(List<Item> medias) {
    var latestMedia = <Widget>[];
    medias.forEach((Item media) {
      var firstKey = media.imageBlurHashes!.primary!.entries.first.key;
      latestMedia.add(
        Container(
          height: listViewHeight,
          width: gapSize,
        ),
      );
      latestMedia.add(
        Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => media.playItem(),
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BlurHash(
                            imageFit: BoxFit.cover,
                            hash: media.imageBlurHashes!.primary![firstKey]))),
                Text(
                  media.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            )),
      );
    });
    return latestMedia;
  }
}
