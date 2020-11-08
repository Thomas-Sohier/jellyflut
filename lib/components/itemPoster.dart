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
        aspectRatio: widget.item.primaryImageAspectRatio ??
            aspectRatio(type: widget.item.type),
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
                            aspectRatio: widget.item.primaryImageAspectRatio ??
                                aspectRatio(type: widget.item.type),
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
                            Positioned(
                                bottom: 5,
                                right: 5,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 6,
                                                    color: Colors.black54,
                                                    spreadRadius: 12)
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          child: Stack(
                                            children: <Widget>[
                                              // Stroked text as border.
                                              Text(
                                                (percentDuration(widget.item) *
                                                        100)
                                                    .round()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 2
                                                      ..color = Colors.white
                                                      ..color = Colors.black),
                                              ),
                                              // Solid text as fill.
                                              Text(
                                                (percentDuration(widget.item) *
                                                        100)
                                                    .round()
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    CircularProgressIndicator(
                                      backgroundColor: Colors.black12,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(color1),
                                      value: percentDuration(widget.item),
                                    ),
                                  ],
                                )),
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
