import 'package:flutter/material.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

import 'details.dart';

class ListVideoItem extends StatelessWidget {
  final Item item;

  const ListVideoItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getEpisodeCustom(seriesId: item.seriesId, itemId: item.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return body(snapshot.data[1]);
            // return placeholderBody();
          }
          return placeholderBody();
        });
  }
}

Widget body(Category category) {
  return Card(
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: category.items == null ? 0 : category.items.length,
        itemBuilder: (context, index) {
          var item = category.items[index];
          var heroTag = item.id + Uuid().v4();
          return videoItem(index, context, item, heroTag);
        },
      ));
}

Widget placeholderBody() {
  return Card(
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(children: [
              Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Skeleton(),
                      Skeleton(
                        nbLine: 3,
                        height: 10,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Skeleton(
                        height: 40,
                      ),
                    ],
                  ))
            ]),
          );
        },
      ));
}

Widget videoItem(int index, BuildContext context, Item item, String heroTag) {
  return Column(children: [
    if (index != 0)
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Divider(
          height: 1,
          color: Colors.grey[500],
        ),
      ),
    InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Details(item: item, heroTag: heroTag)),
      ),
      child: Hero(
        tag: item.id,
        child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 6),
                    child: Text(item.indexNumber.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 22,
                        )),
                  ),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        if (item.isNew())
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              color: Colors.red[700],
                              child: Text('NEW',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
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
                                        fontWeight: FontWeight.w600))),
                            Spacer(),
                            actionIcons(item)
                          ],
                        ),
                        if (item.runTimeTicks != null)
                          Text(
                              printDuration(
                                  Duration(microseconds: item.getDuration())),
                              style: TextStyle(color: Colors.grey[700])),
                        Text((item.overview ?? ''),
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Color(0xFF333333))),
                      ])),
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                          child: GestureDetector(
                              onTap: () async {
                                var url = await getItemURL(item);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stream(
                                          item: item,
                                          streamUrl: url,
                                          playbackInfos: null)),
                                );
                              },
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 32,
                                color: Colors.black,
                              )))),
                ])),
      ),
    )
  ]);
}

Widget actionIcons(Item item, {fav = true, view = true}) {
  return Row(
    children: [
      if (fav)
        FavButton(
          item,
          padding: EdgeInsets.only(left: 8, right: 8),
        ),
      if (view) ViewedButton(item, padding: EdgeInsets.only(left: 8, right: 8))
    ],
  );
}

Future _getEpisodeCustom(
    {@required String seriesId, @required String itemId}) async {
  var futures = <Future>[];
  futures.add(Future.delayed(Duration(milliseconds: 400)));
  futures.add(getShowSeasonEpisode(seriesId, itemId));
  return Future.wait(futures);
}
