import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/skeleton/list_items_skeleton.dart';

import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items/components/episode_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/music_item.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';

part 'components/list_title.dart';
part 'components/list_items_sort.dart';
part 'list_types/list_items_grid.dart';
part 'list_types/list_items_horizontal_list.dart';
part 'list_types/list_items_vertical_list.dart';

class ListItems extends StatefulWidget {
  final Future<Category>? itemsFuture;
  final Category? category;
  final ListType lisType;
  final bool showTitle;
  final bool showSorting;
  final ScrollPhysics physics;
  final double? itemPosterHeight;

  const ListItems.fromFuture(
      {Key? key,
      required this.itemsFuture,
      this.showTitle = false,
      this.showSorting = true,
      this.itemPosterHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : category = null,
        super(key: key);

  const ListItems.fromList(
      {Key? key,
      required this.category,
      this.showTitle = false,
      this.showSorting = true,
      this.itemPosterHeight,
      this.physics = const ClampingScrollPhysics(),
      this.lisType = ListType.POSTER})
      : itemsFuture = null,
        super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

late double listHeight;

class _ListItemsState extends State<ListItems> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    listHeight = widget.itemPosterHeight ?? itemPosterHeight;
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSorting) {
      return ListItemsSort(child: builderSelection());
    }
    return builderSelection();
  }

  Widget builderSelection() {
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
            return Center(child: Text('empty_collection'.tr()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return ListItemsSkeleton(listType: widget.lisType);
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            Text('error_loading_item'.tr(args: ['items']));
          }
          return ListItemsSkeleton(listType: widget.lisType);
        });
  }

  Widget dataBuilder(List<Item> items) {
    final length = items.length;
    items.sort((Item item1, Item item2) =>
        item1.indexNumber?.compareTo(item2.indexNumber ?? length + 1) ??
        length + 1);
    switch (widget.lisType) {
      case ListType.LIST:
        return ListTitle(
          item: items.first,
          showTitle: widget.showTitle,
          child: ListItemsVerticalList(
            items: items,
            scrollPhysics: widget.physics,
            scrollController: scrollController,
          ),
        );
      case ListType.POSTER:
        return ListTitle(
          item: items.first,
          showTitle: widget.showTitle,
          child: ListItemsHorizontalList(
              items: items,
              scrollPhysics: widget.physics,
              scrollController: scrollController),
        );
      case ListType.GRID:
        return ListTitle(
            item: items.first,
            showTitle: widget.showTitle,
            child: ListItemsGrid(
                items: items,
                scrollPhysics: widget.physics,
                scrollController: scrollController));
      default:
        return ListTitle(
          item: items.first,
          showTitle: widget.showTitle,
          child: ListItemsHorizontalList(
              items: items,
              scrollPhysics: widget.physics,
              scrollController: scrollController),
        );
    }
  }
}

Widget itemSelector(final Item item) {
  switch (item.type) {
    case ItemType.AUDIO:
    case ItemType.MUSICALBUM:
      // Music items will fit automatically
      return MusicItem(onPressed: item.playItem, item: item);
    case ItemType.MOVIE:
    case ItemType.EPISODE:
      // Episode items need height to avoid unbounded height
      return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: listHeight, minHeight: 50),
          child: EpisodeItem(item: item));
    default:
      // Episode items need height to avoid unbounded height
      return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: listHeight, minHeight: 50),
          child: EpisodeItem(item: item));
  }
}
