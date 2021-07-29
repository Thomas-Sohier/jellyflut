import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/components/slideRightRoute.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/home/homeCategoryTitle.dart';
import 'package:shimmer/shimmer.dart';

class CollectionHome extends StatefulWidget {
  final Item item;
  const CollectionHome(this.item);

  @override
  State<StatefulWidget> createState() {
    return _CollectionHomeState();
  }
}

const double gapSize = 20;

class _CollectionHomeState extends State<CollectionHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: buildAllCategory(),
    );
  }

  void slideToPageDetail() {
    Navigator.push(
        context,
        SlideRightRoute(
          page: CollectionMain(
            item: widget.item,
          ),
        ));
  }

  Widget buildAllCategory() {
    return FutureBuilder<List<Item>>(
      future: getLatestMedia(
          parentId: widget.item.id,
          fields: 'DateCreated, DateAdded, ImageTags'),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          // If no element in category then we hide it
          if (snapshot.data!.isEmpty) return Container();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    child: HomeCategoryTitle(widget.item,
                        onTap: slideToPageDetail)),
                SizedBox(
                  height: 200,
                  child: displayItems(snapshot.data!),
                )
              ]);
        } else {
          return placeholder();
        }
      },
    );
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        highlightColor: Colors.grey[700]!,
        baseColor: Colors.grey[300]!,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                        height: 30,
                        width: 70,
                        color: Colors.white30,
                      )),
                  Spacer(),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: 30,
                            width: 30,
                            color: Colors.white30,
                          ))),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Container(
                                            height: 200,
                                            width: 200 * (2 / 3),
                                            color: Colors.white30,
                                          )))))),
                    ],
                  ))
            ]));
  }

  Widget displayItems(List<Item> items) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => ItemPoster(
              items[index],
            ));
  }

  dynamic fallbackBlurHash(Map<String, dynamic> bhPrimary, String? key) {
    key ??= bhPrimary.keys.first;
    return bhPrimary[key];
  }
}
