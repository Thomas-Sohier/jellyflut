import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/favButton.dart';
import 'package:jellyflut/screens/details/viewedButton.dart';
import 'package:jellyflut/shared/shared.dart';

import 'critics.dart';

class CardItemWithChild extends StatefulWidget {
  CardItemWithChild(this.item, this.child);

  final Item item;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _CardItemWithChildState();
}

class _CardItemWithChildState extends State<CardItemWithChild> {
  @override
  Widget build(BuildContext context) {
    Item item = widget.item;
    return Card(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  fontSize: 22, fontWeight: FontWeight.bold))),
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
                                    color: Color(0xFF3B5088), fontSize: 18)))),
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
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      actionIcons(item),
                      Spacer(),
                      if (item.runTimeTicks != null)
                        Text(printDuration(Duration(
                            microseconds: (item.runTimeTicks / 10).round())))
                    ],
                  )
                ],
              )),
          Container(
              child: Column(
            children: [widget.child],
          ))
        ],
      ),
    );
  }
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}
