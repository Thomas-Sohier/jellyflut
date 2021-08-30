import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/episodeItem.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class Tab extends StatefulWidget {
  final Item item;

  Tab({Key? key, required this.item}) : super(key: key);

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<Tab> with AutomaticKeepAliveClientMixin {
  late Future<Category> itemsFuture;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    itemsFuture = ItemService.getItems(parentId: widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return constructSeasonView();
  }

  Widget constructSeasonView() {
    return FutureBuilder<Category>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final i = snapshot.data!.items;
            return Column(children: buildListItems(i));
          }
          return skeletonListItem();
        });
  }

  List<Widget> buildListItems(List<Item> items) {
    return items
        .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: EpisodeItem(item: e),
            ))
        .toList();
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
              height: 130,
              width: double.infinity,
              color: Colors.white30,
            )));
  }
}
