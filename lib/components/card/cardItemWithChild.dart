import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/card/cardInfos.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/details/template/small_screens/components/action_button/trailerButton.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../critics.dart';

class CardItemWithChild extends StatefulWidget {
  final Future<Item> itemsToLoad;

  CardItemWithChild({required this.itemsToLoad});

  @override
  State<StatefulWidget> createState() => _CardItemWithChildState();
}

class _CardItemWithChildState extends State<CardItemWithChild> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Card(
            margin: EdgeInsets.zero,
            child: FutureBuilder<Item>(
              future: widget.itemsToLoad,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return cardWithData(snapshot.data!);
                }
                return skeletonCard();
              },
            )));
  }

  Widget skeletonCard() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    ]);
  }

  Widget cardWithData(Item item) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 4, child: titleHeader(item)),
                if (item.hasGenres()) Expanded(flex: 2, child: genres(item)),
              ],
            ),
            if (item.hasRatings())
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Critics(item: item)),
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
    ]);
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

  Widget titleHeader(Item item) {
    if (item.hasParent()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title(item.parentName(), item), subTitle(item.name)],
      );
    } else {
      return title(item.name, item, clickable: false);
    }
  }

  Widget title(String title, Item item, {clickable = true}) {
    return InkWell(
        onTap: () async {
          var parentItem = await getItem(item.getParentId());
          await customRouter
              .replace(DetailsRoute(item: parentItem, heroTag: ''));
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
}

Widget actionIcons(Item item) {
  return Row(
    children: [
      if (item.hasTrailer()) TrailerButton(item),
      FavButton(item),
      ViewedButton(item)
    ],
  );
}
