import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';

import 'critics.dart';

class DetailedItemPoster extends StatefulWidget {
  final Item item;
  final Color textColor;
  final String heroTag;

  const DetailedItemPoster({this.item, this.textColor, this.heroTag});

  @override
  _DetailedItemPosterState createState() => _DetailedItemPosterState();
}

class _DetailedItemPosterState extends State<DetailedItemPoster> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Text(widget.item.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: widget.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 28)),
      ),
      Expanded(
          child: GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                            item: widget.item, heroTag: widget.heroTag)),
                  ),
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child:
                                    ItemPoster(widget.item, showName: false))),
                      ],
                    )),
                Expanded(
                  flex: 3,
                  child: Card(
                      elevation: 6,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(children: [
                            Row(children: [
                              Critics(widget.item, textColor: Colors.black),
                              Spacer(),
                              if (widget.item.runTimeTicks != null)
                                Text(
                                  printDuration(Duration(
                                      microseconds: widget.item.getDuration())),
                                  style: TextStyle(color: Colors.black),
                                )
                            ]),
                            if (widget.item.overview != null) Divider(),
                            if (widget.item.overview != null)
                              Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        removeAllHtmlTags(widget.item.overview),
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      )))
                          ]))),
                )
              ])))
    ]);
  }
}
