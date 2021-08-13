import 'dart:async';
import 'dart:ui';

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
import 'package:jellyflut/screens/details/models/detailsColors.dart';
import 'package:jellyflut/screens/details/template/large_screens/leftDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/rightDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/skeletonRightDetails.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';
import '../../globals.dart';
import './detailHeaderBar.dart';

import 'components/collection.dart';

class Details extends StatefulWidget {
  final Item item;
  final String heroTag;
  const Details({required this.item, required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late PageController pageController;
  late MediaQueryData mediaQuery;
  late String heroTag;
  late Item item;
  late Future<List<dynamic>> itemsFuture;

  // palette color
  var fontColor = Colors.white;

  // Items for photos
  late ListOfItems listOfItems;

  @override
  void initState() {
    heroTag = widget.heroTag;
    listOfItems = ListOfItems();
    item = widget.item;
    itemsFuture = getItemDelayed();
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
        breakpoints: screenBreakpoints,
        mobile: (BuildContext context) => phoneTemplate(),
        tablet: (BuildContext context) => tabletScreenTemplate(),
        desktop: (BuildContext context) => largeScreenTemplate());
  }

  Widget phoneTemplate() {
    mediaQuery = MediaQuery.of(context);
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

  Widget tabletScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: item,
        imageType: 'Backdrop',
      ),
      ClipRect(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
        child: StreamBuilder<DetailsColors>(
            stream: getPaletteColor().stream,
            builder: (context, colorsDetailsSnapshot) => Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: colorsDetailsSnapshot.data != null
                                ? colorsDetailsSnapshot.data!.backgroundColor
                                    .withOpacity(0.4)
                                : Colors.grey.shade700.withOpacity(0.4))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                        child: FutureBuilder<List<dynamic>>(
                            future: itemsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RightDetails(
                                    item: snapshot.data!.elementAt(0),
                                    color: colorsDetailsSnapshot
                                            .data?.backgroundColor ??
                                        Colors.grey.shade200,
                                    fontColor:
                                        colorsDetailsSnapshot.data?.fontColor ??
                                            Colors.black87);
                              }
                              return SkeletonRightDetails();
                            }))
                  ],
                )),
      )),
      DetailHeaderBar(
        color: Colors.white,
        showDarkGradient: false,
        height: 64,
      ),
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
                )),
            Expanded(
                flex: 6,
                child: ClipRect(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
                  child: StreamBuilder<DetailsColors>(
                      stream: getPaletteColor().stream,
                      builder: (context, colorsDetailsSnapshot) => Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: colorsDetailsSnapshot.data != null
                                          ? colorsDetailsSnapshot
                                              .data!.backgroundColor
                                              .withOpacity(0.4)
                                          : Colors.grey.shade700
                                              .withOpacity(0.4))),
                              Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: FutureBuilder<List<dynamic>>(
                                      future: itemsFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return RightDetails(
                                              item: snapshot.data!.elementAt(0),
                                              color: colorsDetailsSnapshot
                                                      .data?.backgroundColor ??
                                                  Colors.grey.shade200,
                                              fontColor: colorsDetailsSnapshot
                                                      .data?.fontColor ??
                                                  Colors.black87);
                                        }
                                        return SkeletonRightDetails();
                                      }))
                            ],
                          )),
                )))
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

  BehaviorSubject<DetailsColors> getPaletteColor() {
    final streamController = BehaviorSubject<DetailsColors>();
    getPalette(item, 'Primary').then((List<PaletteColor> paletteColors) {
      final backgroundColor = paletteColors.elementAt(0).color;
      final fontColor = backgroundColor.computeLuminance() > 0.5
          ? Colors.black87
          : Colors.white70;
      streamController.add(DetailsColors(
          backgroundColor: backgroundColor, fontColor: fontColor));
    });
    return streamController;
  }

  Future<List<dynamic>> getItemDelayed() async {
    final futures = <Future>[];
    futures.add(getItem(item.id));
    futures.add(Future.delayed(Duration(milliseconds: 700)));
    return await Future.wait(futures);
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
          item.isPlayable()
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
