import 'package:flutter/material.dart';
import 'package:jellyflut/components/expandedSection.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

import 'cardItemWithChild.dart';

class CardInfos extends StatefulWidget {
  CardInfos(this.item);

  final Item item;

  @override
  State<StatefulWidget> createState() => _CardInfosState();
}

bool _infos;

class _CardInfosState extends State<CardInfos> {
  @override
  void initState() {
    super.initState();
    _infos = false;
  }

  @override
  Widget build(BuildContext context) {
    Item item = widget.item;

    return Column(
      children: [
        Row(
          children: [
            actionIcons(item),
            Spacer(),
            if (item.runTimeTicks != null)
              Text(printDuration(
                  Duration(microseconds: (item.runTimeTicks / 10).round()))),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                    onTap: () => setState(() {
                          _infos = !_infos;
                        }),
                    child: Icon(Icons.info_outline)))
          ],
        ),
        details(item)
      ],
    );
  }
}

Widget details(Item item) {
  return ExpandedSection(
      expand: _infos,
      child: Column(children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Infos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        if (item.container != null)
          Row(
            children: [
              Text(
                "Codec : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.container),
            ],
          ),
        if (item.dateCreated != null)
          Row(
            children: [
              Text(
                "Date added : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.dateCreated.toLocal().toIso8601String()),
            ],
          ),
        if (item.hasSubtitles != null)
          Row(
            children: [
              Text(
                "Sous titre : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                      item.mediaStreams
                          .where((element) =>
                              element.type.toString() == "Type.SUBTITLE")
                          .map((e) => e.title)
                          .join(", "),
                      overflow: TextOverflow.clip)),
            ],
          ),
        if (item.mediaStreams != null)
          Row(
            children: [
              Text(
                "Audio : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                      item.mediaStreams
                          .where((element) =>
                              element.type.toString() == "Type.AUDIO")
                          .map((e) => e.title)
                          .join(", "),
                      overflow: TextOverflow.clip)),
            ],
          )
      ]));
}
