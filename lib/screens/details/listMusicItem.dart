import 'package:flutter/material.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/shared/shared.dart';

class ListMusicItem extends StatelessWidget {
  final Category category;

  const ListMusicItem(this.category);

  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
            child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.items.length,
          itemBuilder: (context, index) {
            Item item = category.items[index];

            return Column(children: [
              if (index != 0)
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
                            Row(
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: Text(item.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600))),
                                Spacer(),
                                actionIcons(item, view: false)
                              ],
                            ),
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
                                          MusicPlayer().playRemoteItem(item),
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
}

Widget actionIcons(Item item, {fav = true, view = true}) {
  return Row(
    children: [if (fav) FavButton(item), if (view) ViewedButton(item)],
  );
}
