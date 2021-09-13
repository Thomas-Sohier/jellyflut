import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/episode_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/music_item.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:shimmer/shimmer.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';

class ListItems extends StatefulWidget {
  final Future<Category>? itemsFuture;
  final Category? category;
  final ListType lisType;
  final bool showTitle;
  final ScrollPhysics physics;
  final double? itemHeight;

  const ListItems.fromFuture(
      {Key? key,
      required this.itemsFuture,
      this.showTitle = false,
      this.itemHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : category = null,
        super(key: key);

  const ListItems.fromList(
      {Key? key,
      required this.category,
      this.showTitle = false,
      this.itemHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : itemsFuture = null,
        super(key: key);

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
    if (widget.category != null) {
      return dataBuilder(widget.category!.items);
    } else {
      return futureBuild();
    }
  }

  Widget futureBuild() {
    return FutureBuilder<Category>(
        future: widget.itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
              return dataBuilder(snapshot.data!.items);
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

  Widget dataBuilder(List<Item> items) {
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
        // Music items will fit automatically
        return MusicItem(onPressed: item.playItem, item: item);
      case ItemType.MOVIE:
      case ItemType.EPISODE:
        // Episode items need height to avoir unbounded height
        return SizedBox(height: LIST_HEIGHT, child: EpisodeItem(item: item));
      default:
        // Episode items need height to avoir unbounded height
        return SizedBox(height: LIST_HEIGHT, child: EpisodeItem(item: item));
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
