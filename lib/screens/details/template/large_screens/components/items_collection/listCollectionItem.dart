import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/tabsItems.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class ListCollectionItem extends StatelessWidget {
  final Item item;
  final String? title;
  final Future<Category>? future;

  const ListCollectionItem({required this.item, this.title, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: future ??
            getItems(
                parentId: item.id,
                limit: 100,
                fields: 'ImageTags',
                filter: 'IsFolder'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
            return TabsItems(items: snapshot.data!.items);
          }
          return skeletonTab();
        });
  }

  Widget skeletonTab() {
    return Shimmer.fromColors(
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
              height: 50,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) => skeletonButton())),
        ));
  }

  Widget skeletonButton() {
    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Container(
              height: 40,
              width: 150,
              color: Colors.white30,
            )));
  }
}
