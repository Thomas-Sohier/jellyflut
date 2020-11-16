import 'package:flutter/material.dart';
import 'package:jellyflut/models/ScreenDetailsArgument.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:uuid/uuid.dart';

import 'asyncImage.dart';

class ItemPoster extends StatefulWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.showName = true,
      this.type = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final Color textColor;
  final bool showName;
  final String type;
  final BoxFit boxFit;

  @override
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster> {
  final BoxShadow boxShadowColor1 =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);

  final BoxShadow boxShadowColor2 =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);

  String heroTag;

  ScreenDetailsArguments screenDetailsArguments;
  @override
  Widget build(BuildContext context) {
    heroTag = widget.item.id + Uuid().v4();
    return body(heroTag, context);
  }

  Widget body(String heroTag, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Details(item: widget.item, heroTag: heroTag)),
      ),
      child: AspectRatio(
        aspectRatio: handleAspectRatio(widget.item),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Hero(
                  tag: heroTag,
                  child: Row(
                    children: [
                      Flexible(
                        child: Stack(fit: StackFit.expand, children: [
                          AspectRatio(
                            aspectRatio: handleAspectRatio(widget.item),
                            child: AsyncImage(
                              itemsPoster(widget.item),
                              widget.item.imageTags.primary,
                              widget.item.imageBlurHashes,
                              tag: widget.type,
                              boxFit: widget.boxFit,
                            ),
                          ),
                          if (widget.item.userData.playbackPositionTicks !=
                                  null &&
                              widget.item.userData.playbackPositionTicks > 0)
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FractionallySizedBox(
                                        widthFactor: 0.9,
                                        heightFactor: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      (percentDuration(widget
                                                                      .item) *
                                                                  100)
                                                              .round()
                                                              .toString() +
                                                          ' %',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                              Stack(
                                                children: [
                                                  Positioned(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(Radius.circular(
                                                                            80.0)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius:
                                                                          1,
                                                                      color: Colors
                                                                          .black45,
                                                                      spreadRadius:
                                                                          1)
                                                                ]),
                                                            width: double
                                                                .maxFinite,
                                                            height: 3,
                                                          ))),
                                                  Positioned(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          80.0)),
                                                              color: Colors
                                                                  .black26,
                                                            ),
                                                            width: double
                                                                .maxFinite,
                                                            height: 3,
                                                          ))),
                                                  Positioned(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child:
                                                              FractionallySizedBox(
                                                                  widthFactor:
                                                                      percentDuration(
                                                                          widget
                                                                              .item),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                80.0)),
                                                                        color: Colors
                                                                            .white),
                                                                    width: double
                                                                        .maxFinite,
                                                                    height: 3,
                                                                  )))),
                                                ],
                                              )
                                            ],
                                          ),
                                        )))),
                          if (widget.item.userData.played)
                            Positioned.fill(
                                right: 5,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 0.0,
                                                    color: Colors.white,
                                                    spreadRadius: 0.0)
                                              ]),
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green,
                                          )),
                                    ))),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.showName)
                    Expanded(
                      child: Text(
                        widget.item.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                ],
              ),
            ]),
      ),
    );
  }
}

double percentDuration(Item item) {
  return item.userData.playbackPositionTicks / item.runTimeTicks;
}

String itemsPoster(Item item) {
  if (item.type == 'Season') {
    if (item.imageTags.primary != null) return item.id;
    return item.seriesId;
  }
  return item.id;
}

double handleAspectRatio(Item item) {
  if (item.primaryImageAspectRatio != null) {
    if (item.primaryImageAspectRatio > 0.0) {
      return item.primaryImageAspectRatio;
    }
    return aspectRatio(type: item.type);
  }
  return aspectRatio(type: item.type);
}
