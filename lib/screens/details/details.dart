import 'dart:convert';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/cardItemWithChild.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/peoplesList.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/detailsProvider.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
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

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  DetailsProvider detailsProvider;
  @override
  void initState() {
    super.initState();
    detailsProvider = DetailsProvider();
  }

  @override
  void dispose() {
    detailsProvider.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadDetail(widget.item.id);
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
        value: detailsProvider,
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body:
                body(heroTag: widget.heroTag, size: size, item: widget.item)));
  }
}

Widget body(
    {@required Item item, @required String heroTag, @required Size size}) {
  return Stack(children: [
    Hero(
        tag: heroTag,
        child: Container(
            child: Container(
                foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
                child: AsyncImage(
                  item.id,
                  item.imageTags.primary,
                  item.imageBlurHashes,
                  boxFit: BoxFit.cover,
                )),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.2, 0.7, 1],
              ),
            ))),
    SingleChildScrollView(
        child: Consumer<DetailsProvider>(
            builder: (context, detailsProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.10),
                      if (detailsProvider.item?.imageBlurHashes?.logo != null)
                        Container(
                            width: size.width,
                            height: 100,
                            child: AsyncImage(
                              returnImageId(detailsProvider.item),
                              detailsProvider.item.imageTags.primary,
                              detailsProvider.item.imageBlurHashes,
                              boxFit: BoxFit.contain,
                              tag: 'Logo',
                            )),
                      SizedBox(height: size.height * 0.05),
                      buildCard(detailsProvider.item, size, heroTag, context),
                      detailsProvider.item.isFolder == true
                          ? Collection(item)
                          : Container(),
                    ])))
  ]);
}

Widget card(Item item, Size size, String heroTag, BuildContext context) {
  return Stack(overflow: Overflow.visible, children: <Widget>[
    Container(
        padding: EdgeInsets.only(top: 25),
        child: CardItemWithChild(item, Container())),
    Positioned.fill(
        child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 0.5),
        child: GradienButton(
          'Play',
          () {
            _playItem(item, context);
          },
          item: item,
          icon: Icons.play_circle_outline,
        ),
      ),
    ))
  ]);
}

Widget buildCard(Item item, Size size, String heroTag, context) {
  if (item.id != null) {
    return card(item, size, heroTag, context);
  }
  return _placeHolderBody(item, heroTag, size);
}

Widget _placeHolderBody(Item item, String heroTag, Size size) {
  return Container(
      padding: EdgeInsets.only(top: 25),
      child: CardItemWithChild(
        item,
        Container(),
        isSkeleton: true,
      ));
}

void loadDetail(String itemId) {
  getItem(itemId).then((Item _item) => DetailsProvider().updateItem(_item));
}

void _playItem(Item item, BuildContext context) async {
  if (item.type != 'Book') {
    await navigatorKey.currentState.pushNamed('/watch', arguments: item);
  } else {
    readBook(item, context);
  }
}

void readBook(Item item, BuildContext context) async {
  var path = await getEbook(item);
  if (path != null) {
    var sharedPreferences = await SharedPreferences.getInstance();
    EpubViewer.setConfig(
      themeColor: Theme.of(context).primaryColor,
      scrollDirection: EpubScrollDirection.VERTICAL,
      allowSharing: true,
      enableTts: true,
    );

    //TODO save locator
    dynamic book;
    if (sharedPreferences.getString(path) != null) {
      book = json.decode(sharedPreferences.getString(path));
    }

    // Get locator which you can save in your database
    EpubViewer.locatorStream.listen((locator) {
      sharedPreferences.setString(path, locator);
    });

    EpubViewer.open(
      path,
    );
  }
}
