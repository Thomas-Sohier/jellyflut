import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/card/cardInfosChild.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../critics.dart';

class CardItemWithChild extends StatefulWidget {
  CardItemWithChild(this.item, {this.isSkeleton = false});

  final Item item;
  final bool isSkeleton;

  @override
  State<StatefulWidget> createState() => _CardItemWithChildState();
}

class _CardItemWithChildState extends State<CardItemWithChild> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Card(
            margin: EdgeInsets.zero,
            child: FutureBuilder<dynamic>(
              future: _getItemsCustom(itemId: item.id),
              builder: (context, snapshot) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.hasData
                        ? cardWithData(snapshot.data[1])
                        : skeletonCard());
              },
            )));
  }

  List<Widget> skeletonCard() {
    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
          child: Shimmer.fromColors(
              enabled: shimmerAnimation,
              baseColor: shimmerColor1,
              highlightColor: shimmerColor2,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              height: 20,
                              width: double.maxFinite,
                              color: Colors.white,
                            )),
                        Spacer(),
                        Expanded(
                            flex: 2,
                            child: Container(
                              height: 20,
                              width: double.maxFinite,
                              color: Colors.white,
                            ))
                      ],
                    )),
                ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20),
                    itemBuilder: (context, index) => Container(
                          height: 20,
                          margin: EdgeInsets.only(top: 5),
                          width: double.maxFinite,
                          color: Colors.white,
                        ))
              ]))),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0)),
          gradient: LinearGradient(
            begin: Alignment(-1, -2),
            end: Alignment(-1, -0.8),
            colors: [Colors.black12, Colors.grey[100]!],
          ),
        ),
        padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
        child: Column(children: [
          Shimmer.fromColors(
              enabled: shimmerAnimation,
              baseColor: shimmerColor1,
              highlightColor: shimmerColor2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ))
        ]),
      ),
    ];
  }

  List<Widget> cardWithData(Item item) {
    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 4, child: titleHeader()),
                if (item.hasGenres()) Expanded(flex: 2, child: genres(item)),
              ],
            ),
            if (item.hasRatings())
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Critics(item)),
            if (item.hasArtists()) artists(item),
            if (item.hasOverview()) overview(item)
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
            gradient: LinearGradient(
              begin: Alignment(-1, -2),
              end: Alignment(-1, -0.8),
              colors: [Colors.black12, Colors.grey[100]!],
            ),
          ),
          padding: EdgeInsets.all(5),
          child: CardInfos(item))
    ];
  }

  Widget genres(Item item) {
    return Text(item.concatenateGenre(maxGenre: 3),
        overflow: TextOverflow.clip,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal));
  }

  Widget artists(Item item) {
    return Row(
      children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                child: Text(item.concatenateArtists(maxArtists: 5),
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: Color(0xFF3B5088), fontSize: 18)))),
      ],
    );
  }

  Widget overview(Item item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                child: Text(removeAllHtmlTags(item.overview!),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal)))),
      ],
    );
  }

  Widget titleHeader() {
    var item = widget.item;
    if (item.hasParent()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title(item.parentName()), subTitle(item.name)],
      );
    } else {
      return title(item.name, clickable: false);
    }
  }

  Widget title(String title, {clickable = true}) {
    return InkWell(
        onTap: () async {
          var parentItem = await getItem(widget.item.getParentId());
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Details(item: parentItem, heroTag: '')));
        },
        child: Text(title,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
  }

  Widget subTitle(String subTitle) {
    return Text(subTitle,
        overflow: TextOverflow.clip,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400));
  }

  Future _getItemsCustom({required String itemId}) async {
    var futures = <Future>[];
    futures.add(Future.delayed(Duration(milliseconds: 800)));
    futures.add(getItem(itemId));
    return Future.wait(futures);
  }
}

Widget actionIcons(Item item) {
  return Row(
    children: [FavButton(item), ViewedButton(item)],
  );
}
