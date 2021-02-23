import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/card/cardInfosChild.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';

import '../critics.dart';

class CardItemWithChild extends StatefulWidget {
  CardItemWithChild(this.item, {this.isSkeleton = false});

  final Item item;
  final bool isSkeleton;

  @override
  State<StatefulWidget> createState() => _CardItemWithChildState();
}

class _CardItemWithChildState extends State<CardItemWithChild> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return widget.isSkeleton ? skeletonCard() : cardWithData(item);
  }

  Widget skeletonCard() {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 3, child: Skeleton()),
                  Expanded(flex: 2, child: Skeleton()),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: Skeleton()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Skeleton(
                  nbLine: 5,
                )),
              ],
            ),
          ]),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0)),
              gradient: LinearGradient(
                begin: Alignment(-1, -2),
                end: Alignment(-1, -0.8),
                colors: [Colors.black12, Colors.grey[100]],
              ),
            ),
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: Skeleton()),
                    Spacer(
                      flex: 3,
                    ),
                    Expanded(flex: 1, child: Skeleton())
                  ],
                )
              ],
            )),
      ],
    ));
  }

  Widget cardWithData(Item item) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 4, child: titleHeader()),
                        if (item.genres != null && item.genres.isNotEmpty)
                          Expanded(
                              flex: 2,
                              child: Text(item.concatenateGenre(maxGenre: 3),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal))),
                      ],
                    ),
                    if (item.hasRatings())
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Critics(item)),
                    if (item.artists != null && item.artists.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                  child: Text(
                                      item.concatenateArtists(maxArtists: 5),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Color(0xFF3B5088),
                                          fontSize: 18)))),
                        ],
                      ),
                    if (item.overview != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                  child: Text(removeAllHtmlTags(item.overview),
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)))),
                        ],
                      ),
                  ])),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0)),
                    gradient: LinearGradient(
                      begin: Alignment(-1, -2),
                      end: Alignment(-1, -0.8),
                      colors: [Colors.black12, Colors.grey[100]],
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: CardInfos(item))
            ],
          )),
    );
  }

  Widget titleHeader() {
    var item = widget.item;
    if (item.hasParent()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title(item.parentName()), subTitle(item.name)],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title(item.name, clickable: false)],
      );
    }
  }

  Widget title(String title, {clickable = true}) {
    return InkWell(
        onTap: () async {
          var parentItem = await getItem(widget.item.getParentId());
          return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Details(item: parentItem, heroTag: '')));
        },
        child: Text(title,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
  }

  Widget subTitle(String subTitle) {
    return Text(subTitle,
        overflow: TextOverflow.clip,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400));
  }
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}
