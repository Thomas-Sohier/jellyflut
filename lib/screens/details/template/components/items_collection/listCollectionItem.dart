import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tabsItems.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListCollectionItem extends StatefulWidget {
  final Item item;
  final Future<Category>? future;

  const ListCollectionItem({required this.item, this.future});

  @override
  State<StatefulWidget> createState() => _ListCollectionItemState();
}

class _ListCollectionItemState extends State<ListCollectionItem> {
  late Future<Category> categoryFuture;

  @override
  void initState() {
    categoryFuture = widget.future != null
        ? widget.future!
        : ItemService.getItems(
            parentId: widget.item.id,
            limit: 100,
            fields: 'ImageTags, RecursiveItemCount',
            filter: 'IsFolder');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
              return TabsItems(items: snapshot.data!.items);
            }
            return SizedBox();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return skeletonTab();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            Text('Error while loading ${widget.item.getCollectionType()}');
          }
          return SizedBox();
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
