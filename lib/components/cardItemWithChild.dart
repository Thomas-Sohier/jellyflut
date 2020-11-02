import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/cardInfosChild.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/shared/shared.dart';

import 'critics.dart';

class CardItemWithChild extends StatefulWidget {
  CardItemWithChild(this.item, this.child, {this.isSkeleton = false});

  final Item item;
  final Widget child;
  final bool isSkeleton;

  @override
  State<StatefulWidget> createState() => _CardItemWithChildState();
}

class _CardItemWithChildState extends State<CardItemWithChild> {
  @override
  Widget build(BuildContext context) {
    Item item = widget.item;
    return Column(children: [
      widget.isSkeleton ? skeletonCard() : cardWithData(item),
      Container(
          child: Column(
        children: [widget.child],
      ))
    ]);
  }
}

Widget skeletonCard() {
  return Card(
    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
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
                padding: EdgeInsets.all(12),
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
        )),
  );
}

Widget cardWithData(Item item) {
  return Card(
    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
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
                      if (item.name != null)
                        Expanded(
                            flex: 3,
                            child: Text(item.name,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                      if (item.genres != null && item.genres.length > 0)
                        Expanded(
                            flex: 2,
                            child: Text(item.genres.first,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal))),
                    ],
                  ),
                ),
                if (item.communityRating != null || item.criticRating != null)
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Critics(item)),
                Row(
                  children: [
                    if (item.artists != null)
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                              child: Text(
                                  item.artists
                                      .map((e) => e.name)
                                      .join(", ")
                                      .toString(),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Color(0xFF3B5088),
                                      fontSize: 18)))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.overview != null)
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
                padding: EdgeInsets.all(5),
                child: CardInfos(item))
          ],
        )),
  );
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}
