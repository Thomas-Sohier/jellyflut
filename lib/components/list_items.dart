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
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

class ListItems extends StatefulWidget {
  final Future<Category>? itemsFuture;
  final Category? category;
  final ListType lisType;
  final bool showTitle;
  final ScrollPhysics physics;
  final double? itemPosterHeight;

  const ListItems.fromFuture(
      {Key? key,
      required this.itemsFuture,
      this.showTitle = false,
      this.itemPosterHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : category = null,
        super(key: key);

  const ListItems.fromList(
      {Key? key,
      required this.category,
      this.showTitle = false,
      this.itemPosterHeight,
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
    LIST_HEIGHT = widget.itemPosterHeight ?? itemPosterHeight;
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
    final length = items.length;
    items.sort((Item item1, Item item2) =>
        item1.indexNumber?.compareTo(item2.indexNumber ?? length + 1) ??
        length + 1);
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
              item.type.getValue().toLowerCase().capitalize(),
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 12),
            child
          ]);
    }
    return child;
  }

  Widget showItemsAsList(List<Item> items) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: widget.physics,
        itemBuilder: (context, index) => Column(
              children: [
                itemSelector(items.elementAt(index)),

                // If item is not last and screen is mobile then we show a
                // divider for better readability
                if (deviceType == DeviceScreenType.mobile &&
                    index + 1 < items.length)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 4, bottom: 4),
                    child: Divider(
                        height: 2,
                        thickness: 2,
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                  )
              ],
            ));
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
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: LIST_HEIGHT, minHeight: 50),
            child: EpisodeItem(item: item));
      default:
        // Episode items need height to avoir unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: LIST_HEIGHT, minHeight: 50),
            child: EpisodeItem(item: item));
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
