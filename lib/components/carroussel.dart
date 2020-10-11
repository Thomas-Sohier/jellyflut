import 'package:flutter/material.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';

import 'critics.dart';

class CarousselItem extends StatefulWidget {
  CarousselItem(this.items,
      {this.textColor = Colors.white, this.detailMode = false});

  final List<Item> items;
  final Color textColor;
  final bool detailMode;

  @override
  State<StatefulWidget> createState() => _CarousselItemState();
}

class _CarousselItemState extends State<CarousselItem> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return _buildCarousel(widget.items);
  }

  Widget _buildCarousel(List<Item> items) {
    double customViewportFraction = widget.detailMode ? 1 : 0.7;
    return PageView.builder(
      controller: PageController(viewportFraction: customViewportFraction),
      onPageChanged: (int index) => setState(() => _index = index),
      pageSnapping: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int itemIndex) {
        return _buildCarouselItem(context, itemIndex, items);
      },
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, int itemIndex, List<Item> items) {
    Item i = items[itemIndex];
    return Transform.scale(
        scale: itemIndex == _index ? 0.9 : 0.7,
        child: widget.detailMode
            ? carrousselDetailItem(i, widget.textColor)
            : carrousselDefault(i, widget.textColor));
  }
}

Widget carrousselDetailItem(Item item, Color textColor) {
  return Column(children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(item.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w600, fontSize: 28)),
    ),
    Expanded(
        child: Row(children: [
      Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () => navigatorKey.currentState
                          .pushNamed("/details", arguments: item),
                      child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Hero(
                              tag: "poster-${item.id}",
                              child: AsyncImage(
                                item,
                                item.imageBlurHashes,
                                boxFit: BoxFit.contain,
                              ))))),
            ],
          )),
      Expanded(
        flex: 3,
        child: Column(children: [
          Critics(item, textColor: Colors.white),
          if (item.overview != null)
            new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      removeAllHtmlTags(item.overview),
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    )))
        ]),
      )
    ]))
  ]);
}

Widget carrousselDefault(Item item, Color textColor) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () => navigatorKey.currentState
                          .pushNamed("/details", arguments: item),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Hero(
                              tag: "poster-${item.id}",
                              child: AsyncImage(
                                item,
                                item.imageBlurHashes,
                              ))))),
              Text(item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22)),
            ])
      ]);
}
