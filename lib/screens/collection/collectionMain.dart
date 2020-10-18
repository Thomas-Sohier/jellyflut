import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/components/carrousselBackGroundImage.dart';
import 'package:jellyflut/components/itemPoster.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:jellyflut/shared/shared.dart';

class CollectionMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

Item backgroundItem;

PageController pageController = PageController(viewportFraction: 0.8);

class _CollectionMainState extends State<CollectionMain> {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as Item;
    return Scaffold(
        floatingActionButton: MusicPlayerFAB(),
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (item.collectionType == 'movies' || item.collectionType == 'books')
            CarrousselBackGroundImage(),
          Positioned(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              if (item.collectionType == 'movies' ||
                  item.collectionType == 'books')
                head(item, context),
              listOfItems(item),
            ],
          )))
        ])));
  }

  Widget listOfItems(Item item) {
    return FutureBuilder<Category>(
        future: getCategory(parentId: item.id, limit: 100),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildItemsGrid(snapshot.data.items);
          } else {
            return buildSkeletonItemsGrid();
          }
        });
  }

  Widget buildSkeletonItemsGrid() {
    return Padding(
        padding: EdgeInsets.all(6),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: aspectRatio(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return Column(children: [
                Skeleton(
                  height: 140,
                  colors: [Colors.white24, Colors.white30, Colors.white24],
                ),
                Skeleton(
                  colors: [Colors.white24, Colors.white30, Colors.white24],
                )
              ]);
            }));
  }

  Widget buildItemsGrid(List<Item> items) {
    return Padding(
        padding: EdgeInsets.all(6),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: aspectRatio(type: items.first.type),
                mainAxisSpacing: 15,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return ItemPoster(items[index]);
            }));
  }

  Widget head(Item item, BuildContext context) {
    var size = MediaQuery.of(context).size;
    var filter = 'IsNotFolder,IsUnplayed';
    var fields =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview';

    return Container(
        padding: EdgeInsets.only(top: size.height * 0.02),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: FutureBuilder<Category>(
                future: getItemsRecursive(item.id,
                    limit: 5, fields: fields, filter: filter, sortBy: 'Random'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarousselItem(snapshot.data.items, detailMode: true);
                  }
                  return Container();
                })));
  }
}
