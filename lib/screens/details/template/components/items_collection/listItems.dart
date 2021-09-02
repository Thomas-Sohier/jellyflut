import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/enum/listType.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/episodeItem.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/musicItem.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:shimmer/shimmer.dart';
import 'package:jellyflut/shared/stringExtensions.dart';

class ListItems extends StatefulWidget {
  final Future<Category> itemsFuture;
  final ListType lisType;
  final bool showTitle;
  final ScrollPhysics physics;
  final double? itemHeight;

  const ListItems(
      {Key? key,
      required this.itemsFuture,
      this.showTitle = false,
      this.itemHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late final double LIST_HEIGHT;

  @override
  void initState() {
    super.initState();
    LIST_HEIGHT = widget.itemHeight ?? itemHeight;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: widget.itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
              return datatBuilder(snapshot.data!.items);
            }
            return SizedBox();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return skeletonBuilder();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            Text('Error while loading datas');
          }
          return SizedBox();
        });
  }

  Widget datatBuilder(List<Item> items) {
    switch (widget.lisType) {
      case ListType.LIST:
        return listTitle(child: showItemsAsList(items), item: items.first);

      case ListType.POSTER:
        return listTitle(child: showItemsAsPoster(items), item: items.first);
      default:
        return listTitle(child: showItemsAsPoster(items), item: items.first);
    }
  }

  Widget skeletonBuilder() {
    switch (widget.lisType) {
      case ListType.LIST:
        return skeletonList();
      case ListType.POSTER:
        return skeletonPoster();
      default:
        return skeletonPoster();
    }
  }

  Widget listTitle({required Widget child, required Item item}) {
    if (widget.showTitle) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getEnumValue(item.type.toString()).toLowerCase().capitalize(),
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 12),
            child
          ]);
    }
    return child;
  }

  Widget showItemsAsList(List<Item> items) {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: widget.physics,
        itemBuilder: (context, index) => itemSelector(items.elementAt(index)));
  }

  Widget itemSelector(Item item) {
    switch (item.type) {
      case ItemType.AUDIO:
      case ItemType.MUSICALBUM:
        return MusicItem(onPressed: item.playItem, item: item);
      case ItemType.MOVIE:
      case ItemType.EPISODE:
        return SizedBox(height: itemHeight, child: EpisodeItem(item: item));
      default:
        return SizedBox(height: itemHeight, child: EpisodeItem(item: item));
    }
  }

  Widget showItemsAsPoster(List<Item> items) {
    return SizedBox(
      height: LIST_HEIGHT,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          physics: widget.physics,
          itemBuilder: (context, index) => ItemPoster(items.elementAt(index))),
    );
  }

  Widget skeletonList() {
    return Shimmer.fromColors(
      baseColor: personnal_theme.shimmerColor1,
      highlightColor: personnal_theme.shimmerColor2,
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
        baseColor: personnal_theme.shimmerColor1,
        highlightColor: personnal_theme.shimmerColor2,
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
