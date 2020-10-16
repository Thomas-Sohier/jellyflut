import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/components/carrousselBackGroundImage.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/background.dart';

class CollectionMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

Item backgroundItem;

PageController pageController = new PageController(viewportFraction: 0.8);

class _CollectionMainState extends State<CollectionMain> {
  @override
  Widget build(BuildContext context) {
    final Item item = ModalRoute.of(context).settings.arguments as Item;
    return Scaffold(
        floatingActionButton: MusicPlayerFAB(),
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (item.collectionType == "movies" || item.collectionType == "books")
            CarrousselBackGroundImage(),
          Positioned(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              if (item.collectionType == "movies" ||
                  item.collectionType == "books")
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
            List<Item> items = snapshot.data.items;
            return Padding(
                padding: EdgeInsets.all(6),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.totalRecordCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 6),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed("/details", arguments: items[index]),
                          child: Column(children: [
                            Expanded(
                                child: AsyncImage(items[index].id,
                                    items[index].imageBlurHashes)),
                            Text(
                              items[index].name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]));
                    }));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget head(Item item, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String filter = "IsNotFolder,IsUnplayed";
    String fields =
        "ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview";

    return Container(
        padding: EdgeInsets.only(top: size.height * 0.02),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: FutureBuilder<Category>(
                future: getItemsRecursive(item.id,
                    limit: 5, fields: fields, filter: filter, sortBy: "Random"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarousselItem(snapshot.data.items, detailMode: true);
                  }
                  return Container();
                })));
  }
}
