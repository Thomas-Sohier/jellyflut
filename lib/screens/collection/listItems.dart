import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/detailedItemPoster.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/carrousselModel.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ListItems extends StatefulWidget {
  final double headerBarHeight;
  const ListItems({Key key, this.headerBarHeight = 64}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  // Scroll controller
  ScrollController _scrollController;

  // Carousel provider
  CarrousselModel carrousselModel;

  // Items
  ListOfItems listOfItems;

  @override
  void initState() {
    super.initState();
    listOfItems = ListOfItems();
    listOfItems.showMoreItem();
    // set first image background
    carrousselModel = CarrousselModel();
    listOfItems
        .getheaderItems()
        .then((items) => carrousselModel.changeItem(items.first.id));
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    listOfItems.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildItemsGrid();
  }

  Widget buildItemsGrid() {
    var size = MediaQuery.of(context).size;
    var numberOfItemRow = (size.width / 150).round();
    // var spacing = numberOfItemRow
    return Consumer<ListOfItems>(
        builder: (context, listOfItems, child) => listOfItems.items.isNotEmpty
            ? CustomScrollView(controller: _scrollController, slivers: <Widget>[
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: widget.headerBarHeight,
                )),
                SliverToBoxAdapter(
                  child: Column(children: [
                    if (listOfItems.getTypeOfItems() == 'movies' ||
                        listOfItems.getTypeOfItems() == 'books')
                      head(context),
                    sortItems(),
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              listOfItems.items.first.getPrimaryAspectRatio(),
                          crossAxisCount: numberOfItemRow,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext c, int index) {
                        return ItemPoster(
                          listOfItems.items[index],
                        );
                      }, childCount: listOfItems.items.length)),
                )
              ])
            : ListItemsSkeleton());
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
            onPressed: () => ListOfItems().sortItemByDate(),
          ),
          IconButton(
            icon: Icon(
              Icons.sort_by_alpha,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => ListOfItems().sortItemByName(),
          ),
        ],
      ),
    );
  }

  Widget head(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: listOfItems.getheaderItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return carouselSlider(snapshot.data);
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
                carrousselModel.changeItem(items[index].id),
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
      listOfItems.showMoreItem();
    }
  }
}
