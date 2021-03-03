import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/card/cardItemWithChild.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';

import 'collection.dart';

class Details extends StatefulWidget {
  final Item item;
  final String heroTag;
  const Details({@required this.item, @required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

final playableItems = [
  'musicalbum',
  'music',
  'movie',
  'series',
  'season',
  'episode',
  'book'
];

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  Size size;
  String heroTag;
  Item item;

  @override
  void initState() {
    heroTag = widget.heroTag;
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return MusicPlayerFAB(
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: body()));
  }

  Widget body() {
    return Stack(alignment: Alignment.center, children: [
      Hero(tag: heroTag, child: BackgroundImage(item: item)),
      Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          constraints: BoxConstraints(maxWidth: 600),
          child: ListView(cacheExtent: 1000, children: [
            buildElements(),
            SizedBox(
              height: 20,
            ),
            Collection(item),
          ])),
    ]);
  }

  Widget buildElements() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.10),
          if (item?.imageBlurHashes?.logo != null) logo(item, size),
          SizedBox(height: size.height * 0.05),
          futureItemDetails(item: item),
        ]);
  }

  Widget logo(Item item, Size size) {
    return Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        constraints: BoxConstraints(maxWidth: 400),
        height: 100,
        child: AsyncImage(
          item.correctImageId(searchType: 'logo'),
          item.correctImageTags(searchType: 'logo'),
          item.imageBlurHashes,
          boxFit: BoxFit.contain,
          tag: 'Logo',
        ));
  }

  Widget futureItemDetails({@required Item item}) {
    return FutureBuilder<dynamic>(
      future: _getItemsCustom(itemId: item.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildCard(snapshot.data[1]);
        }
        return _placeHolderBody(item, size);
      },
    );
  }

  Widget buildCard(Item detailedItem) {
    if (detailedItem.id != null) {
      return card(detailedItem);
    }
    return Container();
  }

  Widget card(Item detailedItem) {
    return Stack(clipBehavior: Clip.hardEdge, children: <Widget>[
      Container(
          padding: EdgeInsets.only(top: 25),
          child: CardItemWithChild(detailedItem)),
      playableItems.contains(item.type.trim().toLowerCase())
          ? Positioned.fill(
              child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.5),
                child: PaletteButton(
                  'Play',
                  () {
                    item.playItem();
                  },
                  item: item,
                  icon: Icons.play_circle_outline,
                ),
              ),
            ))
          : Container()
    ]);
  }

  Widget _placeHolderBody(Item item, Size size) {
    return Container(
        child: CardItemWithChild(
      item,
      isSkeleton: true,
    ));
  }

  Future _getItemsCustom({@required String itemId}) async {
    var futures = <Future>[];
    futures.add(Future.delayed(Duration(milliseconds: 400)));
    futures.add(getItem(itemId));
    return Future.wait(futures);
  }
}
