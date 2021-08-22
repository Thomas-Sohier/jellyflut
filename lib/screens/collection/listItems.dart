import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/detailedItemPoster.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
import 'package:jellyflut/providers/items/itemsProvider.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

class ListItems extends StatefulWidget {
  final double headerBarHeight;
  const ListItems({Key? key, this.headerBarHeight = 64}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  // Scroll controller
  late final ScrollController _scrollController;

  // Carousel provider
  late final CarrousselProvider carrousselProvider;

  // Items
  late final ItemsProvider itemsProvider;

  @override
  void initState() {
    super.initState();
    itemsProvider = ItemsProvider();
    itemsProvider.showMoreItem();
    // set first image background
    carrousselProvider = CarrousselProvider();
    itemsProvider
        .getheaderItems()
        .then((items) => carrousselProvider.changeItem(items.first));
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    itemsProvider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildItemsGrid();
  }

  Widget buildItemsGrid() {
    var size = MediaQuery.of(context).size;
    var numberOfItemRow = (size.width / itemHeight * (4 / 3)).round();
    // var spacing = numberOfItemRow
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 82, 8, 8),
      child: Consumer<ItemsProvider>(
          builder: (context, itemsProvider, child) => itemsProvider
                  .items.isNotEmpty
              ? CustomScrollView(controller: _scrollController, slivers: <
                  Widget>[
                  SliverToBoxAdapter(
                    child: Column(children: [
                      if (itemsProvider.getTypeOfItems() != null &&
                          (itemsProvider.getTypeOfItems()!.contains('movie') ||
                              itemsProvider.getTypeOfItems()!.contains('Book')))
                        head(context),
                      sortItems(),
                    ]),
                  ),
                  SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              itemsProvider.items.first.getPrimaryAspectRatio(),
                          crossAxisCount: numberOfItemRow,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext c, int index) {
                        return ItemPoster(
                          itemsProvider.items[index],
                        );
                      }, childCount: itemsProvider.items.length)),
                ])
              : ListItemsSkeleton()),
    );
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

  Widget head(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: itemsProvider.getheaderItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return carouselSlider(snapshot.data!);
          }
          return Container();
        });
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      itemsProvider.showMoreItem();
    }
  }
}
