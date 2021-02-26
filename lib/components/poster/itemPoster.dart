import 'package:flutter/material.dart';
import 'package:jellyflut/components/banner/LeftBanner.dart';
import 'package:jellyflut/components/banner/RightBanner.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progressBar.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatelessWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.showName = true,
      this.showParent = true,
      this.type = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final String heroTag;
  final Color textColor;
  final bool showName;
  final bool showParent;
  final String type;
  final BoxFit boxFit;

  void _onTap(String heroTag) {
    Navigator.push(
      navigatorKey.currentContext,
      MaterialPageRoute(
          builder: (context) => Details(item: item, heroTag: heroTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var posterHeroTag = heroTag ?? item.id + Uuid().v4();
    return GestureDetector(
        onTap: () => _onTap(posterHeroTag),
        child: body(posterHeroTag, context));
  }

  Widget body(String heroTag, BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                  aspectRatio: item.getPrimaryAspectRatio(),
                  child: Stack(fit: StackFit.expand, children: [
                    Hero(
                        tag: heroTag,
                        child: Poster(
                            showParent: showParent,
                            type: type,
                            boxFit: boxFit,
                            item: item)),
                    Stack(
                      children: [
                        if (item.isNew())
                          Positioned(top: 8, left: 0, child: newBanner()),
                        if (item.isPlayed())
                          Positioned(top: 8, right: 0, child: playedBanner()),
                      ],
                    ),
                    if (item.hasProgress())
                      Positioned.fill(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: progressBar())),
                  ])),
            ),
          ],
        ),
      ),
      if (showName)
        Text(
          showParent ? item.parentName() : item.name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w700, fontSize: 16),
        )
    ]);
  }

  Widget newBanner() {
    return CustomPaint(
        painter: LeftBanner(color: Colors.red[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Text('NEW',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }

  Widget playedBanner() {
    return CustomPaint(
        painter: RightBanner(color: Colors.green[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )));
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: item)));
  }
}
