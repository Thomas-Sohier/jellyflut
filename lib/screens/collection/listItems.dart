import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/detailedItemPoster.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
import 'package:jellyflut/providers/items/itemsProvider.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

class ListItems extends StatefulWidget {
  final double headerBarHeight;
  final Item parentItem;
  const ListItems(
      {Key? key, this.headerBarHeight = 64, required this.parentItem})
      : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late final ScrollController _scrollController;
  late final CarrousselProvider carrousselProvider;
  late final Future<Category> categoryFuture;
  late final bool canPop;

  @override
  void initState() {
    super.initState();
    // set first image background
    categoryFuture = ItemService.getItems(
        parentId: widget.parentItem.id,
        sortBy: 'SortName',
        fields:
            'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated, DateAdded',
        imageTypeLimit: 1,
        startIndex: 0,
        includeItemTypes: widget.parentItem
            .getCollectionType()
            .map((e) => getEnumValue(e.toString()))
            .toList()
            .join(','),
        limit: 100);
    canPop = customRouter.canPopSelfOrChildren;
    carrousselProvider = CarrousselProvider();
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildItemsGrid();
  }

  Widget buildItemsGrid() {
    // var spacing = numberOfItemRow
    final paddingTop = canPop ? 82.0 : 8.0;
    return Padding(
        padding: EdgeInsets.fromLTRB(8, paddingTop, 8, 8),
        child: FutureBuilder<Category>(
            future: categoryFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!.items;
                if (items.isNotEmpty) {
                  return view(items);
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error,
                          size: 24, color: Theme.of(context).primaryColor),
                      Text(
                        'No items found in collection',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                );
              }
              return ListItemsSkeleton();
            }));
  }

  Widget view(List<Item> items) {
    var size = MediaQuery.of(context).size;
    var numberOfItemRow = (size.width / itemHeight * (4 / 3)).round();
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      SliverToBoxAdapter(
        child: Column(children: [
          // if (widget.parentItem.isPlayable()) head(context),
          sortItems(),
        ]),
      ),
      SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: items.first.getPrimaryAspectRatio(),
              crossAxisCount: numberOfItemRow,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5),
          delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
            return ItemPoster(
              items[index],
            );
          }, childCount: items.length)),
    ]);
  }

  Widget sortItems() {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            onPressed: () => ItemsProvider().sortItemByDate(),
          ),
          IconButton(
            icon: Icon(
              Icons.sort_by_alpha,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => ItemsProvider().sortItemByName(),
          ),
        ],
      ),
    );
  }

  Widget carouselSlider(List<Item> items) {
    return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: (16 / 9),
            viewportFraction: (16 / 9) / 2,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, _) =>
                carrousselProvider.changeItem(items[index]),
            height: 300),
        items: items.map((item) {
          var heroTag = item.id + Uuid().v4();
          return DetailedItemPoster(
            item: item,
            textColor: Colors.white,
            heroTag: heroTag,
          );
        }).toList());
  }

  // void _scrollListener() {
  //   if (_scrollController.offset >=
  //           _scrollController.position.maxScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     itemsProvider.showMoreItem();
  //   }
  // }
}
