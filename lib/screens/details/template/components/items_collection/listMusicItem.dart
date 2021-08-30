import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/musicItem.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListMusicItem extends StatefulWidget {
  final Item item;

  const ListMusicItem({required this.item});

  @override
  State<StatefulWidget> createState() => _ListMusicItemState();
}

class _ListMusicItemState extends State<ListMusicItem> {
  late Future<Category> musicFuture;

  @override
  void initState() {
    musicFuture = ItemService.getItems(parentId: widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: musicFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return musicItems(snapshot.data!.items);
          }
          return skeletonListItem();
        });
  }

  Widget musicItems(List<Item> items) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => MusicItem(
            onPressed: () => items.elementAt(index).playItem(),
            item: items.elementAt(index)));
  }

  Widget skeletonListItem() {
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
              itemBuilder: (context, index) => skeletonItem())),
    );
  }

  Widget skeletonItem() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: 80,
              width: double.infinity,
              color: Colors.white30,
            )));
  }
}
