import 'dart:convert';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/cardItemWithChild.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: body(
            heroTag: widget.heroTag,
            size: size,
            item: widget.item,
            context: context));
  }
}

Widget body(
    {@required Item item,
    @required String heroTag,
    @required Size size,
    @required BuildContext context}) {
  return Stack(children: [
    Hero(tag: heroTag, child: backgroundImage(item)),
    SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          futureItemDetails(item: item, heroTag: heroTag, size: size),
          item.isFolder == true ? Collection(item) : Container(),
        ]))
  ]);
}

Widget futureItemDetails(
    {@required Item item, @required String heroTag, @required Size size}) {
  return FutureBuilder<dynamic>(
    future: _getItemsCustom(itemId: item.id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return detailsElements(
            size: size,
            item: snapshot.data[1],
            heroTag: heroTag,
            context: context);
      } else {
        return _placeHolderBody(item, heroTag, size);
      }
    },
  );
}

Widget detailsElements(
    {@required Size size,
    @required Item item,
    @required String heroTag,
    @required BuildContext context}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.10),
        if (item?.imageBlurHashes?.logo != null) logo(item, size),
        SizedBox(height: size.height * 0.05),
        buildCard(item, size, heroTag, context),
      ]);
}

Widget logo(Item item, Size size) {
  return Container(
      width: size.width,
      height: 100,
      child: AsyncImage(
        correctImageId(item, type: 'logo'),
        correctImageTags(item, type: 'logo'),
        item.imageBlurHashes,
        boxFit: BoxFit.contain,
        tag: 'Logo',
      ));
}

Widget backgroundImage(Item item) {
  return Container(
      child: Container(
          foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
          child: AsyncImage(
            correctImageId(item),
            correctImageTags(item),
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
      ));
}

Widget buildCard(Item item, Size size, String heroTag, context) {
  if (item.id != null) {
    return card(item, size, heroTag, context);
  }
  return _placeHolderBody(item, heroTag, size);
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

Widget _placeHolderBody(Item item, String heroTag, Size size) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.10),
        SizedBox(
          height: 100,
        ), // Logo
        Container(
            padding: EdgeInsets.only(top: 25),
            child: CardItemWithChild(
              item,
              Container(),
              isSkeleton: true,
            ))
      ]);
}

Future _getItemsCustom({@required String itemId}) async {
  var futures = <Future>[];
  futures.add(Future.delayed(Duration(milliseconds: 400)));
  futures.add(getItem(itemId));
  return Future.wait(futures);
}

void _playItem(Item item, BuildContext context) async {
  if (item.type != 'Book') {
    var url = await getItemURL(item);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Stream(
                item: item,
                streamUrl: url,
              )),
    );
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
