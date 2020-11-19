import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/details/itemDialog.dart';
import 'package:jellyflut/screens/form/editItemInfos.dart';
import 'package:jellyflut/shared/shared.dart';

class ListMusicItem extends StatelessWidget {
  final Item item;

  const ListMusicItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getMusicCustom(itemId: item.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return body(snapshot.data[1]);
          }
          return placeholderBody();
        });
  }
}

Widget body(Category category) {
  return Card(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
          child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: category.items.length,
        itemBuilder: (context, index) {
          var item = category.items[index];

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
              onTap: () => MusicPlayer().playRemoteItem(item),
              onLongPress: () {
                ItemDialog(item, context).showMusicDialog();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 15, 20),
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
                                        .join(', ')
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
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: actionIcons(item, view: false))
                    ]),
              ),
            )
          ]);
        },
      )));
}

Widget placeholderBody() {
  return Card(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
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
                  flex: 8,
                  child: Column(
                    children: [
                      Skeleton(),
                      Skeleton(nbLine: 3),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Skeleton(
                        height: 60,
                      ),
                    ],
                  ))
            ]),
          );
        },
      )));
}

Widget actionIcons(Item item, {fav = true, view = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [if (fav) FavButton(item), if (view) ViewedButton(item)],
  );
}

Widget animate(Item item) {
  Animation<Offset> _offsetAnimation;

  return SlideTransition(
    position: _offsetAnimation,
    child: EditItemInfos(item),
  );
}

Future _getMusicCustom({@required String itemId}) async {
  var futures = <Future>[];
  futures.add(Future.delayed(Duration(milliseconds: 400)));
  futures.add(getItems(parentId: itemId));
  return Future.wait(futures);
}
