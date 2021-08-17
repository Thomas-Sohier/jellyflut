import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/tabsItems.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListCollectionItem extends StatefulWidget {
  final Item item;
  final String? title;
  final Future<Category>? future;

  const ListCollectionItem({required this.item, this.title, this.future});

  @override
  State<StatefulWidget> createState() => _ListCollectionItemState();
}

class _ListCollectionItemState extends State<ListCollectionItem> {
  late Future<Category> categoryFuture;

  @override
  void initState() {
    categoryFuture = widget.future != null
        ? widget.future!
        : getItems(
            parentId: widget.item.id,
            limit: 100,
            fields: 'ImageTags',
            filter: 'IsFolder');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: categoryFuture,
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
