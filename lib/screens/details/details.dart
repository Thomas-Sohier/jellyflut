import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/models/itemDetails.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/category.dart';

import '../../main.dart';
import 'collection.dart';

var itemDetail = new ItemDetail();

class Details extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final Item item = ModalRoute.of(context).settings.arguments as Item;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // bottomNavigationBar: BottomBar(),
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: FutureBuilder<ItemDetail>(
          future: getItemDetails(item),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              itemDetail = snapshot.data;
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

Widget body(ItemDetail itemDetail, Size size, BuildContext context) {
  return Stack(
    children: [
      Container(
          child: Container(
              foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
              child: AsyncImage(itemDetail.id, itemDetail.imageBlurHashes)),
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
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.10),
            Container(
                width: 200,
                child: AsyncImage(
                  itemDetail.id,
                  itemDetail.imageBlurHashes,
                  tag: "Logo",
                )),
            SizedBox(height: size.height * 0.05),
            Stack(children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25),
                child: Card(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 25, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (itemDetail.name != null)
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                      child: Text(itemDetail.name,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)))),
                            Spacer(),
                            if (itemDetail.genres != null)
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                      child: Text(itemDetail.genres.first,
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (itemDetail.overview != null)
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                      child: Text(itemDetail.overview,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  height: 50,
                  width: 250,
                  top: 0,
                  left: 75,
                  child: GradienButton(
                    "Play",
                    _playItem,
                    item: itemDetail,
                    // _playItem(context, itemDetail),
                    icon: Icons.play_circle_outline,
                  )),
            ]),
            SizedBox(
              height: size.height * 0.05,
            ),
            if (itemDetail.isFolder == true)
              Card(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Collection(itemDetail.id)])))
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
                  item.id,
                  item.imageBlurHashes,
                  tag: "Logo",
                )),
            SizedBox(height: size.height * 0.10),
            // GradienButton(
            //   "Play",
            //   () {},
            //   icon: Icons.play_circle_outline,
            // ),
            SizedBox(height: size.height * 0.05),
            Card(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                    child: Text(item.name,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold))))),
                      ],
                    ),
                    // if (itemDetail.isFolder == true) Collection(itemDetail)
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

void _playItem() async {
  navigatorKey.currentState.pushNamed("/watch", arguments: itemDetail);
}
