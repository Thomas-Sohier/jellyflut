import 'package:flutter/material.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/seasonItem.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListVideoItem extends StatefulWidget {
  final Item item;

  const ListVideoItem({required this.item});

  @override
  State<StatefulWidget> createState() => _ListVideoItemState();
}

class _ListVideoItemState extends State<ListVideoItem> {
  late Future<dynamic> episodeFuture;

  @override
  void initState() {
    episodeFuture = _getEpisodeCustom(
        seriesId: widget.item.seriesId!, itemId: widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: episodeFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                title(),
                body(snapshot.data[1]),
              ],
            );
          }
          return skeletonListItem();
        });
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Epsiodes',
            style: TextStyle(
                fontSize: 26,
                fontFamily: 'HindMadurai',
                color: Colors.white.withAlpha(210))),
      ),
    );
  }

  Widget body(Category category) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: category.items.length,
      itemBuilder: (context, index) {
        var item = category.items[index];
        return SeasonItem(item: item);
      },
    );
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

  Future _getEpisodeCustom(
      {required String seriesId, required String itemId}) async {
    var futures = <Future>[];
    futures.add(Future.delayed(Duration(milliseconds: 800)));
    futures.add(getShowSeasonEpisode(seriesId, itemId));
    return Future.wait(futures);
  }
}
