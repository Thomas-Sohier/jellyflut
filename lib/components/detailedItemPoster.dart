import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

import 'critics.dart';

class DetailedItemPoster extends StatefulWidget {
  final Item item;
  final Color textColor;
  final String heroTag;

  const DetailedItemPoster(
      {required this.item, required this.textColor, required this.heroTag});

  @override
  _DetailedItemPosterState createState() => _DetailedItemPosterState();
}

class _DetailedItemPosterState extends State<DetailedItemPoster> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: personnal_theme.Theme.defaultThemeData.copyWith(
          textTheme: personnal_theme.Theme.getTextThemeWithColor(Colors.black)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(widget.item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 28)),
        ),
        Expanded(
            child: GestureDetector(
                onTap: () => customRouter.push(
                    DetailsRoute(item: widget.item, heroTag: widget.heroTag)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 3,
                          child: ItemPoster(widget.item, showName: false)),
                      SizedBox(
                        width: 24,
                      ),
                      Flexible(
                        flex: 5,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 100, maxWidth: 600),
                          child: Card(
                              elevation: 6,
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(children: [
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          widget.item.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Critics(
                                        item: widget.item,
                                        fontSize: 18,
                                      ),
                                      Spacer(),
                                      if (widget.item.runTimeTicks != null)
                                        Text(
                                          printDuration(Duration(
                                              microseconds:
                                                  widget.item.getDuration())),
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
                                                removeAllHtmlTags(
                                                    widget.item.overview!),
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(fontSize: 18),
                                              )))
                                  ]))),
                        ),
                      ),
                    ])))
      ]),
    );
  }
}
