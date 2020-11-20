import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progressBar.dart';
import 'package:jellyflut/components/poster/seenIcon.dart';
import 'package:jellyflut/models/ScreenDetailsArgument.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.showName = true,
      this.type = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final String heroTag;
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
    heroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
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
                child: Row(
                  children: [
                    Flexible(
                      child: Stack(fit: StackFit.expand, children: [
                        Hero(
                            tag: heroTag,
                            child: Poster(
                                type: widget.type,
                                boxFit: widget.boxFit,
                                item: widget.item)),
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
                                          child: ProgressBar(
                                              item: widget.item))))),
                        if (widget.item.userData.played)
                          Positioned.fill(
                              right: 5,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SeenIcon()))),
                      ]),
                    ),
                  ],
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
