import 'dart:convert';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/cardItemWithChild.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'collection.dart';
import '../../components/favButton.dart';
import '../../components/viewedButton.dart';

class Details extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

Item item = new Item();

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    item = ModalRoute.of(context).settings.arguments as Item;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // bottomNavigationBar: BottomBar(),
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: FutureBuilder<Item>(
          future: getItem(item.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return body(snapshot.data, size, context);
            } else if (snapshot.hasError) {
              return Container(child: Text("Error"));
            } else {
              return _placeHolderBody(item, size);
            }
          },
        ));
  }
}

Widget body(Item item, Size size, BuildContext context) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Container(
          child: Container(
              foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
              child: AsyncImage(
                item.id,
                item.imageBlurHashes,
                boxFit: BoxFit.fitHeight,
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
          )),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.10),
            if (item.imageBlurHashes.logo != null)
              Container(
                  width: size.width,
                  height: 100,
                  child: AsyncImage(
                    returnImageId(item),
                    item.imageBlurHashes,
                    boxFit: BoxFit.contain,
                    tag: "Logo",
                  )),
            SizedBox(height: size.height * 0.05),
            Stack(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 25),
                  child: CardItemWithChild(
                    item,
                    item.isFolder == true ? Collection(item) : Container(),
                  )),
              Positioned(
                  height: 50,
                  width: 250,
                  top: 0,
                  left: 75,
                  child: GradienButton(
                    "Play",
                    () {
                      _playItem(item, context);
                    },
                    item: item,
                    // _playItem(context, item),
                    icon: Icons.play_circle_outline,
                  )),
            ]),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      )
    ],
  );
}

Widget _placeHolderBody(Item item, Size size) {
  return Stack(
    children: [
      Hero(
        tag: "poster-${item.id}",
        child: Container(
            child: Container(
                foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
                child: AsyncImage(item.id, item.imageBlurHashes)),
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
                stops: [0, 0.2, 0.6, 1],
              ),
            )),
      ),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.10),
            Container(
                width: 200,
                child: AsyncImage(
                  returnImageId(item),
                  item.imageBlurHashes,
                  tag: "Logo",
                )),
            SizedBox(height: size.height * 0.10),
            SizedBox(height: size.height * 0.05),
            Container(
                padding: EdgeInsets.only(top: 25),
                child: CardItemWithChild(
                  item,
                  Container(),
                  isSkeleton: true,
                ))
          ],
        ),
      )
    ],
  );
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}

void _playItem(Item item, BuildContext context) async {
  if (item.type != "Book") {
    navigatorKey.currentState.pushNamed("/watch", arguments: item);
  } else {
    readBook(context);
  }
}

void readBook(BuildContext context) async {
  String path = await getEbook(item);
  if (path != null) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    EpubViewer.setConfig(
      themeColor: Theme.of(context).primaryColor,
      scrollDirection: EpubScrollDirection.VERTICAL,
      allowSharing: true,
      enableTts: true,
    );

    //TODO save locator
    dynamic book;
    if (sharedPreferences.getString(path) != null)
      book = json.decode(sharedPreferences.getString(path));

    // Get locator which you can save in your database
    EpubViewer.locatorStream.listen((locator) {
      sharedPreferences.setString(path, locator);
    });

    EpubViewer.open(
      path,
    );
  }
}
