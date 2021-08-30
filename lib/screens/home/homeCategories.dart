import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/homeCategoryTitle.dart';
import 'package:jellyflut/services/user/userservice.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategories extends StatefulWidget {
  final Item item;
  const HomeCategories(this.item);

  @override
  State<StatefulWidget> createState() {
    return _HomeCategoriesState();
  }
}

class _HomeCategoriesState extends State<HomeCategories>
    with AutomaticKeepAliveClientMixin {
  final double height = 220;
  final double gapSize = 20;
  late Future<List<Item>> itemsFuture;

  @override
  void initState() {
    itemsFuture = UserService.getLatestMedia(
        parentId: widget.item.id, fields: 'DateCreated, DateAdded, ImageTags');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: Colors.transparent,
      child: categoryBuilder(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void slideToPageDetail() {
    customRouter.push(CollectionParentRoute(
      item: widget.item,
    ));
  }

  Widget categoryBuilder() {
    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.isEmpty) {
            return Container();
          }
          return buildCategory(snapshot.data!);
        } else {
          return placeholder();
        }
      },
    );
  }

  Widget buildCategory(List<Item> items) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
              child: HomeCategoryTitle(widget.item, onTap: slideToPageDetail)),
          SizedBox(
            height: itemHeight,
            child: displayItems(items),
          )
        ]);
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
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
                              height: itemHeight,
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
                                            height: height,
                                            width: height * (2 / 3),
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
        itemBuilder: (context, index) => ItemPoster(items[index]));
  }

  dynamic fallbackBlurHash(Map<String, dynamic> bhPrimary, String? key) {
    key ??= bhPrimary.keys.first;
    return bhPrimary[key];
  }
}
