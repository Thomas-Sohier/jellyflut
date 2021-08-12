import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/card/cardItemWithChild.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/components/peoplesList.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';
import 'package:jellyflut/screens/details/template/large_screens/leftDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/rightDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/skeletonRightDetails.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

  // palette color
  var color1 = Colors.grey.shade700;
  var color2 = Colors.grey.shade800;
  var fontColor = Colors.white;

  // Items for photos
  late ListOfItems listOfItems;

  @override
  void initState() {
    heroTag = widget.heroTag;
    listOfItems = ListOfItems();
    item = widget.item;
    getPaletteColorDelayed();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayerFAB(
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: item.type != ItemType.PHOTO ? body() : photoItem()));
  }

  Widget body() {
    return responsiveBuilder();
  }

  Widget responsiveBuilder() {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) => phoneTemplate(),
        tablet: (BuildContext context) => largeScreenTemplate(),
        desktop: (BuildContext context) => largeScreenTemplate());
  }

  Widget phoneTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: item,
        imageType: 'Primary',
      ),
      Stack(alignment: Alignment.topCenter, children: [
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(children: [
              SizedBox(
                height: 64,
              ),
              if (item.hasLogo()) logo(item, mediaQuery.size),
              if (!item.hasLogo())
                SizedBox(
                  height: 64,
                  width: double.infinity,
                ),
              card(item, Colors.white),
              Collection(item),
            ])),
        DetailHeaderBar(
          color: Colors.white,
          height: 64,
        ),
      ])
    ]);
  }

  Widget largeScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: item,
        imageType: 'Backdrop',
      ),
      Stack(alignment: Alignment.topCenter, children: [
        Column(children: [
          Expanded(
              child: Row(children: [
            SizedBox(
              height: 64,
            ),
            Expanded(
                flex: 4,
                child: LeftDetails(
                  item: item,
                  heroTag: heroTag,
                  color: color1,
                )),
            Expanded(
                flex: 6,
                child: ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
                        child: Container(
                            decoration:
                                BoxDecoration(color: color2.withOpacity(0.4)),
                            child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: FutureBuilder<Item>(
                                    future: getItem(item.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Expanded(
                                            flex: 6,
                                            child: RightDetails(
                                                item: snapshot.data!,
                                                color: color2,
                                                fontColor: fontColor));
                                      }
                                      return SkeletonRightDetails();
                                    }))))))
          ])),
        ]),
        DetailHeaderBar(
          color: Colors.white,
          showDarkGradient: false,
          height: 64,
        )
      ])
    ]);
  }

  void getPaletteColorDelayed() async {
    var futures = <Future>[];
    futures.add(Future.delayed(Duration(milliseconds: 1200)));
    futures.add(getPalette(item, 'Primary'));
    await Future.wait(futures).then((List<dynamic> data) {
      setState(() {
        color1 = data[1].elementAt(0).color;
        color2 = data[1].elementAt(2).color;
        fontColor =
            color2.computeLuminance() > 0.5 ? Colors.black87 : Colors.white70;
      });
    });
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
    return Container(
        width: size.width,
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

  Widget card(Item item, Color fontColor) {
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
                    icon: Icon(Icons.play_circle_outline, color: fontColor),
                  ),
                )
              : Container()
        ]);
  }

  Future<List<PaletteColor>> getPalette(Item item, String searchType) async {
    final paletteGenerator = await gePalette(getItemImageUrl(
        item.correctImageId(searchType: searchType),
        item.correctImageTags(searchType: searchType),
        imageBlurHashes: item.imageBlurHashes,
        type: searchType));
    return paletteGenerator.paletteColors;
  }
}
