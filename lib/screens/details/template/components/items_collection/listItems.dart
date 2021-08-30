import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/listType.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListItems extends StatefulWidget {
  final Future<Category> itemsFuture;
  final ListType lisType;

  const ListItems(
      {Key? key, required this.itemsFuture, this.lisType = ListType.POSTER})
      : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final LIST_HEIGHT = itemHeight;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: widget.itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
              switch (widget.lisType) {
                case ListType.LIST:
                  return showItemsAsList(snapshot.data!.items);
                case ListType.POSTER:
                  return showItemsAsPoster(snapshot.data!.items);
                default:
                  return showItemsAsPoster(snapshot.data!.items);
              }
            }
            return SizedBox();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            switch (widget.lisType) {
              case ListType.LIST:
                return skeletonList();
              case ListType.POSTER:
                return skeletonPoster();
              default:
                return skeletonPoster();
            }
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            Text('Error while loading datas');
          }
          return SizedBox();
        });
  }

  Widget showItemsAsList(List<Item> items) {
    return ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => ItemPoster(items.elementAt(index)));
  }

  Widget showItemsAsPoster(List<Item> items) {
    return SizedBox(
      height: LIST_HEIGHT,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ItemPoster(items.elementAt(index))),
    );
  }

  Widget skeletonList() {
    return Shimmer.fromColors(
      baseColor: shimmerColor1,
      highlightColor: shimmerColor2,
      child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) => skeletonListItem())),
    );
  }

  Widget skeletonListItem() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: LIST_HEIGHT,
              width: double.infinity,
              color: Colors.white30,
            )));
  }

  Widget skeletonPoster() {
    return Shimmer.fromColors(
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: LIST_HEIGHT,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) => skeletonPosterItem()),
            )));
  }

  Widget skeletonPosterItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: SizedBox(
          height: LIST_HEIGHT,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Container(
                  height: LIST_HEIGHT,
                  width: double.infinity,
                  color: Colors.white30,
                )),
          )),
    );
  }
}
