import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/card/cardItemWithChild.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import './detailHeaderBar.dart';

import 'collection.dart';

class Details extends StatefulWidget {
  final Item item;
  final String heroTag;
  const Details({required this.item, required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

final playableItems = [
  ItemType.AUDIO,
  ItemType.MUSICALBUM,
  ItemType.MUSICVIDEO,
  ItemType.MOVIE,
  ItemType.SERIES,
  ItemType.SEASON,
  ItemType.EPISODE,
  ItemType.BOOK,
  ItemType.VIDEO
];

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late PageController pageController;
  late MediaQueryData mediaQuery;
  late String heroTag;
  late Item item;

  // Items for photos
  late ListOfItems listOfItems;

  @override
  void initState() {
    heroTag = widget.heroTag;
    listOfItems = ListOfItems();
    item = widget.item;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return MusicPlayerFAB(
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: item.type != ItemType.PHOTO ? body() : photoItem()));
  }

  Widget body() {
    return Stack(alignment: Alignment.topCenter, children: [
      Hero(tag: heroTag, child: BackgroundImage(item: item)),
      Stack(alignment: Alignment.topCenter, children: [
        playableItem(),
        DetailHeaderBar(
          color: Colors.white,
          height: 64,
        )
      ]),
    ]);
  }

  Widget playableItem() {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(children: [
          if (item.hasLogo()) logo(item, mediaQuery.size),
          if (!item.hasLogo())
            SizedBox(
              height: 64,
              width: double.infinity,
            ),
          card(item),
          Collection(item),
        ]));
  }

  Widget photoItem() {
    if (listOfItems.items.isEmpty) {
      return PhotoView(
        heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
        imageProvider: NetworkImage(
            getItemImageUrl(item.correctImageId(), item.correctImageTags()!)),
      );
    }
    var startAt = listOfItems.items.indexOf(item);
    pageController = PageController(initialPage: startAt);
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        var _item = listOfItems.items[index];
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(getItemImageUrl(
              _item.correctImageId(), _item.correctImageTags()!)),
          initialScale: PhotoViewComputedScale.contained,
        );
      },
      itemCount: listOfItems.items.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
      pageController: pageController,
    );
  }

  Widget logo(Item item, Size size) {
    final margin = size.height * 0.05;
    return Container(
        width: size.width,
        margin: EdgeInsets.only(top: margin, bottom: margin),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        constraints: BoxConstraints(maxWidth: 400),
        height: 100,
        child: AsyncImage(
          item.correctImageId(searchType: 'logo'),
          item.correctImageTags(searchType: 'logo'),
          item.imageBlurHashes!,
          boxFit: BoxFit.contain,
          tag: 'Logo',
        ));
  }

  Widget card(Item item) {
    return Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 25),
              child: CardItemWithChild(item)),
          playableItems.contains(item.type)
              ? ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: mediaQuery.size.width * 0.5),
                  child: PaletteButton(
                    'Play',
                    () {
                      item.playItem();
                    },
                    item: item,
                    icon: Icons.play_circle_outline,
                  ),
                )
              : Container()
        ]);
  }
}
