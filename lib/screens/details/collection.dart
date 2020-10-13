import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/favButton.dart';
import 'package:jellyflut/screens/details/viewedButton.dart';
import 'package:jellyflut/shared/shared.dart';

import '../../globals.dart';
import '../../main.dart';

class Collection extends StatefulWidget {
  final Item item;

  const Collection(this.item);

  @override
  State<StatefulWidget> createState() {
    return _CollectionState();
  }
}

const double gapSize = 20;

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
      future: collectionItems(widget.item),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
              child: Column(
            children: [
              if (widget.item.isFolder && widget.item.type == "MusicAlbum")
                displayItems(snapshot.data)
              else if (widget.item.isFolder && widget.item.type == "Season")
                displayVideosItems(snapshot.data)
              else
                displayCollection(snapshot.data)
            ],
          ));
        } else {
          return Container();
        }
      },
    );
  }

  Widget displayCollection(Category category) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: CarousselItem(
            category.items,
            textColor: Colors.white,
          ),
        ));
  }

  Widget displayItems(Category category) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
            child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.items.length,
          itemBuilder: (context, index) {
            Item item = category.items[index];

            return Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Divider(
                  color: Colors.grey[500],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(item.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                            item.artists != null
                                ? Text(
                                    item.artists
                                        .map((e) => e.name)
                                        .join(", ")
                                        .toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFF3B5088), fontSize: 14))
                                : Container(),
                            item.artists != null
                                ? Text(
                                    printDuration(Duration(
                                        microseconds:
                                            (item.runTimeTicks / 10).round())),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Color(0xFF5774C2)))
                                : Container()
                          ])),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: item.artists != null
                                  ? GestureDetector(
                                      onTap: () =>
                                          AssetsAudioPlayer.newPlayer().open(
                                            Audio.network(
                                              createURl(item),
                                              metas: Metas(
                                                title: item.name,
                                                artist: item.artists
                                                    .map((e) => e.name)
                                                    .join(", ")
                                                    .toString(),
                                                album: item.album,
                                                image: MetasImage.network(
                                                    getItemImageUrl(item.id,
                                                        item.imageBlurHashes)), //can be MetasImage.network
                                              ),
                                            ),
                                            showNotification: true,
                                          ),
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 32,
                                        color: Colors.black,
                                      ))
                                  : Container())),
                    ]),
              )
            ]);
          },
        )));
  }

  Widget displayVideosItems(Category category) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
            child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.items == null ? 0 : category.items.length,
          itemBuilder: (context, index) {
            Item item = category.items[index];

            return Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                navigatorKey.currentState
                                    .pushNamed("/details", arguments: item);
                              },
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 10,
                                            child: Text(item.name.trim(),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        Spacer(),
                                        actionIcons(item)
                                      ],
                                    ),
                                    if (item.runTimeTicks != null)
                                      Text(
                                          printDuration(Duration(
                                              microseconds:
                                                  (item.runTimeTicks / 10)
                                                      .round())),
                                          style: TextStyle(
                                              color: Colors.grey[700])),
                                    Text(
                                        (item.overview == null
                                            ? ""
                                            : item.overview),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF333333))),
                                  ]))),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                              child: GestureDetector(
                                  onTap: () {
                                    navigatorKey.currentState
                                        .pushNamed("/watch", arguments: item);
                                  },
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 32,
                                    color: Colors.black,
                                  )))),
                    ]));
          },
        )));
  }

  String createURl(Item item) {
    String url = "${server.url}/Audio/${item.id}/stream.mp3";
    return url;
  }
}

String msToHumanReadable(int ms) {
  return DateTime.fromMicrosecondsSinceEpoch(ms).hour.toString();
}

Future collectionItems(Item item) {
  if (item.type == "Series" || item.type == "MusicAlbum") {
    return getCategory(parentId: item.id, limit: 100);
  } else {
    return getShowSeasonEpisode(item.seriesId, item.id);
  }
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}
