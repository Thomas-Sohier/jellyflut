import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/skeleton/list_items_skeleton.dart';

import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items/components/episode_item.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'bloc/collection_bloc.dart';
import 'components/music_item.dart';

part 'components/list_title.dart';
part 'components/list_items_sort.dart';
part 'components/carousel_background.dart';
part 'list_types/list_items_grid.dart';
part 'list_types/list_items_horizontal_list.dart';
part 'list_types/list_items_vertical_list.dart';

class ListItems extends StatefulWidget {
  final Future<Category>? itemsFuture;
  final Category? category;
  final ListType lisType;
  final bool showTitle;
  final bool showIfEmpty;
  final bool showSorting;
  final ScrollPhysics physics;
  final double? itemPosterHeight;

  const ListItems.fromFuture(
      {Key? key,
      required this.itemsFuture,
      this.showTitle = false,
      this.showIfEmpty = true,
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
      this.showIfEmpty = true,
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
  late final CollectionBloc collectionBloc;
  late final List<ListType> listTypes;

  // late final CarrousselProvider carrousselProvider;

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      collectionBloc.add(LoadMoreItems());
    }
  }

  @override
  void initState() {
    super.initState();
    // carrousselProvider = CarrousselProvider();
    listHeight = widget.itemPosterHeight ?? itemPosterHeight;
    collectionBloc = CollectionBloc();
    listTypes = ListType.values;
    collectionBloc.listType.add(widget.lisType);
    scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);

    // init Items
    if (widget.itemsFuture != null) {
      widget.itemsFuture!.then((Category category) {
        collectionBloc.add(AddItem(items: category.items));
      });
    } else {
      collectionBloc.add(AddItem(items: widget.category?.items ?? <Item>[]));
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    collectionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocProvider.value(
      value: collectionBloc,
      child: sortingThenbuildSelection(),
    ));
  }

  Widget sortingThenbuildSelection() {
    if (widget.showSorting) {
      return ListItemsSort(
          listTypes: listTypes, child: Expanded(child: buildList()));
    }
    return buildList();
  }

  Widget buildList() {
    return BlocBuilder<CollectionBloc, CollectionState>(
        bloc: collectionBloc,
        builder: (context, collectionState) {
          if (collectionState is CollectionLoadedState) {
            if (collectionBloc.items.isNotEmpty) {
              return dataBuilder(collectionBloc.items);
            }
            return emptyCollection();
          } else if (collectionState is CollectionErrorState) {
            return Center(child: Text('error'.tr()));
          } else if (collectionState is CollectionLoadingState) {
            return ListItemsSkeleton(
                listType: collectionBloc.listType.stream.value);
          }
          return const SizedBox();
        });
  }

  Widget emptyCollection() {
    if (widget.showIfEmpty) {
      return Center(child: Center(child: Text('empty_collection'.tr())));
    }
    return const SizedBox();
  }

  Widget dataBuilder(List<Item> items) {
    return StreamBuilder<ListType>(
        stream: collectionBloc.listType.stream,
        builder:
            (BuildContext context, AsyncSnapshot<ListType> snapshotListType) {
          switch (snapshotListType.data) {
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
                child: ListItemsGrid(
                    items: items,
                    scrollPhysics: widget.physics,
                    scrollController: scrollController),
              );
          }
        });
  }
}
