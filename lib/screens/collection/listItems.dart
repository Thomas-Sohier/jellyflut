import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/carroussel/carroussel.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key key}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  // Scroll controller
  ScrollController _scrollController;

  // Items
  ListOfItems listOfItems;

  @override
  void initState() {
    super.initState();
    listOfItems = ListOfItems();
    listOfItems.showMoreItem();
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
    return Consumer<ListOfItems>(
        builder: (context, listOfItems, child) => listOfItems.items.isNotEmpty
            ? CustomScrollView(controller: _scrollController, slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(children: [
                    if (listOfItems.getParentItem().collectionType ==
                            'movies' ||
                        listOfItems.getParentItem().collectionType == 'books')
                      head(listOfItems.getParentItem(), context),
                    sortItems(),
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(4),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              aspectRatio(type: listOfItems.items.first.type) -
                                  .1,
                          crossAxisCount: 3,
                          mainAxisSpacing: 25,
                          crossAxisSpacing: 5),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext c, int index) {
                        return ItemPoster(listOfItems.items[index]);
                      }, childCount: listOfItems.items.length)),
                )
              ])
            : Container());
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

  Widget head(Item item, BuildContext context) {
    var filter = 'IsNotFolder,IsUnplayed';
    var fields =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview';

    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: FutureBuilder<List<Item>>(
            future: listOfItems.getheaderItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarousselItem(snapshot.data, detailMode: true);
              }
              return Container();
            }));
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      listOfItems.showMoreItem();
    }
  }
}
