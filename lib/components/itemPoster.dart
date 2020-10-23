import 'package:flutter/material.dart';
import 'package:jellyflut/models/ScreenDetailsArgument.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:uuid/uuid.dart';

import 'asyncImage.dart';

class ItemPoster extends StatelessWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.showName = true,
      this.type = 'Primary',
      this.boxFit});

  final Item item;
  final Color textColor;
  final bool showName;
  final String type;
  final BoxFit boxFit;

  final BoxShadow boxShadowColor1 =
      BoxShadow(blurRadius: 6, color: Colors.black38, spreadRadius: 1);
  final BoxShadow boxShadowColor2 =
      BoxShadow(blurRadius: 6, color: Colors.black54, spreadRadius: 1);

  String heroTag;
  ScreenDetailsArguments screenDetailsArguments;
  @override
  Widget build(BuildContext context) {
    heroTag = item.id + Uuid().v4();
    screenDetailsArguments = ScreenDetailsArguments(item, heroTag);
    return Hero(tag: heroTag, child: body(context));
  }

  Widget body(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed('/details', arguments: screenDetailsArguments),
      child: AspectRatio(
        aspectRatio:
            item.primaryImageAspectRatio ?? aspectRatio(type: item.type),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Stack(fit: StackFit.expand, children: [
                  AspectRatio(
                    aspectRatio: item.primaryImageAspectRatio ??
                        aspectRatio(type: item.type),
                    child: AsyncImage(
                      item.id,
                      item.imageTags.primary,
                      item.imageBlurHashes,
                      tag: type,
                      boxFit: boxFit,
                    ),
                  ),
                  if (item.userData.playbackPositionTicks != null &&
                      item.userData.playbackPositionTicks > 0)
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
                                        (percentDuration(item) * 100)
                                            .round()
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 2
                                              ..color = Colors.white
                                              ..color = Colors.black),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        (percentDuration(item) * 100)
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
                              valueColor: AlwaysStoppedAnimation<Color>(color1),
                              value: percentDuration(item),
                            ),
                          ],
                        )),
                  if (item.userData.played)
                    Positioned.fill(
                        right: 5,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 0,
                                            color: Colors.white,
                                            spreadRadius: 0)
                                      ]),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                  )),
                            ))),
                ]),
              ),
              if (showName)
                Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
            ]),
      ),
    );
  }
}

double percentDuration(Item item) {
  return item.userData.playbackPositionTicks / item.runTimeTicks;
}
