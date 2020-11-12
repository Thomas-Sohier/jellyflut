import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/components/expandedSection.dart';
import 'package:jellyflut/components/peoplesList.dart';
import 'package:jellyflut/components/unorderedList.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/itemDialogActions.dart';
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
    var item = widget.item;

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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      onTap: () => setState(() {
                            _infos = !_infos;
                          }),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.info_outline))),
                ))
          ],
        ),
        details(item, context)
      ],
    );
  }
}

Widget tabs(Item item, BuildContext context) {
  return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 3,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 250),
          child: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  icon: Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                )
              ]),
              Flexible(
                  child: TabBarView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infos(item, context),
                ),
                item?.people != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PeoplesList(item.people),
                      )
                    : Container(),
                Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemDialogActions(item, null),
                    ))
              ]))
            ],
          )));
}

Widget details(Item item, BuildContext context) {
  return ExpandedSection(expand: _infos, child: tabs(item, context));
}

Widget infos(Item item, BuildContext context) {
  var titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  var valueStyle = TextStyle(fontSize: 16);
  var formatter = DateFormat('dd-MM-yyyy');
  return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        if (item.videoType != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video : ',
                style: titleStyle,
              ),
              UnorderedList(
                  texts: item.mediaStreams
                      .where((element) =>
                          element.type.trim().toLowerCase() == 'video')
                      .map((e) => e.displayTitle + ', ' + e.codec)
                      .toList()),
            ],
          ),
        if (item.container != null)
          Row(
            children: [
              Text(
                'Container : ',
                style: titleStyle,
              ),
              Text(
                item.container,
                style: valueStyle,
              ),
            ],
          ),
        if (item.dateCreated != null)
          Row(
            children: [
              Text(
                'Date added : ',
                style: titleStyle,
              ),
              Text(
                formatter.format(item.dateCreated),
                style: valueStyle,
              ),
            ],
          ),
        if (item.hasSubtitles != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sous titre : ',
                style: titleStyle,
              ),
              UnorderedList(
                  texts: item.mediaStreams
                      .where((element) =>
                          element.type.trim().toLowerCase() == 'subtitle')
                      .map((e) => e.displayTitle + ', ' + e.codec)
                      .toList())
            ],
          ),
        if (item.mediaStreams != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Audio : ',
                style: titleStyle,
              ),
              UnorderedList(
                  texts: item.mediaStreams
                      .where((element) =>
                          element.type.trim().toLowerCase() == 'audio')
                      .map((e) => e.displayTitle + ', ' + e.codec)
                      .toList()),
            ],
          )
      ]));
}
