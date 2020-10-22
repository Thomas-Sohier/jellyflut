import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
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
                child: GestureDetector(
                    onTap: () => setState(() {
                          _infos = !_infos;
                        }),
                    child: Icon(Icons.info_outline)))
          ],
        ),
        details(item, context)
      ],
    );
  }
}

Widget details(Item item, BuildContext context) {
  return ExpandedSection(
      expand: _infos,
      child: Column(children: [
        Divider(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () => deleteDialogItem(item, context).then((value) {
                        if (value) {
                          deleteItem(item.id).then((int statusCode) {
                            if (statusCode == HttpStatus.noContent) {
                              Navigator.pop(context);
                            } else {
                              AlertDialog(
                                content: Text("Error, cannot delete item..."),
                              );
                            }
                          });
                        }
                      }),
                  child: Icon(Icons.delete_outline)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.edit_outlined),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Infos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        if (item.container != null)
          Row(
            children: [
              Text(
                'Codec : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.container),
            ],
          ),
        if (item.dateCreated != null)
          Row(
            children: [
              Text(
                'Date added : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.dateCreated.toLocal().toIso8601String()),
            ],
          ),
        if (item.hasSubtitles != null)
          Row(
            children: [
              Text(
                'Sous titre : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                      item.mediaStreams
                          .where((element) =>
                              element.type.toString() == "Type.SUBTITLE")
                          .map((e) => e.displayTitle)
                          .join(', '),
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
                          .map((e) => e.displayTitle)
                          .join(", "),
                      overflow: TextOverflow.clip)),
            ],
          )
      ]));
}

Future<bool> deleteDialogItem(Item item, BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Text(
              'Delete ${item.name} ?',
              style: TextStyle(),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  'This action cannot be reversed !',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleDialogOption(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'no',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    SimpleDialogOption(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.red[700],
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    spreadRadius: 2)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: InkWell(
                              child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ],
                ),
              )
            ]);
      });
}
