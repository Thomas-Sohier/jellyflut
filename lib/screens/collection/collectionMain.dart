import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/components/carrousselBackGroundImage.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/carrousselModel.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/collection/listItems.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class CollectionMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

Item backgroundItem;
PageController pageController = PageController(viewportFraction: 0.8);

class _CollectionMainState extends State<CollectionMain> {
  bool isLoading = false;
  bool blockItemsLoading = false;
  int pageCount = 1;
  int startIndex = 0;
  var item;
  var items = <Item>[];
  var itemsToShow = <Item>[];
  ScrollController _scrollController;

  // Provider
  ListOfItems listOfItems;
  CarrousselModel carrousselModel;

  @override
  void initState() {
    super.initState();
    listOfItems = ListOfItems();
    carrousselModel = CarrousselModel();
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ListOfItems().reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    item = ModalRoute.of(context).settings.arguments as Item;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (item.collectionType == 'movies' || item.collectionType == 'books')
            ChangeNotifierProvider.value(
                value: carrousselModel, child: CarrousselBackGroundImage()),
          Positioned(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.04),
                    child: ChangeNotifierProvider.value(
                      value: listOfItems,
                      child: Column(
                        children: [
                          if (item.collectionType == 'movies' ||
                              item.collectionType == 'books')
                            head(item, context),
                          sortItems(),
                          listItems(item),
                        ],
                      ),
                    ),
                  )))
        ])));
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      showMoreItem();
    }
  }

  void showMoreItem() {
    // if (items.isEmpty) return;
    // var startIndex = (pageCount - 1) * 20;
    // var endIndex =
    //     items.length > pageCount * 20 ? pageCount * 20 : items.length;
    // if (startIndex > endIndex) return;
    // var _items = items.sublist(startIndex, endIndex);
    if (blockItemsLoading == false) {
      blockItemsLoading = true;
      getItems(item.id,
              sortBy: 'Name',
              fields: 'DateCreated, DateAdded',
              startIndex: startIndex,
              includeItemTypes: getCollectionItemType(item.collectionType),
              limit: 100)
          .then((_category) {
        ListOfItems().addNewItems(_category.items);
        if (_category.items.isNotEmpty) {
          startIndex = startIndex + 100;
          pageCount++;
        }
        blockItemsLoading = false;
      });
    }
  }

  Widget listItems(Item item) {
    return FutureBuilder<Category>(
        future: getItems(item.id,
            filter: '',
            sortBy: 'Name',
            fields: 'DateCreated, DateAdded',
            startIndex: startIndex,
            includeItemTypes: getCollectionItemType(item.collectionType),
            limit: 100),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            items = snapshot.data.items;
            showMoreItem();
            return ListItems();
          } else {
            return ListItemsSkeleton();
          }
        });
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
        child: FutureBuilder<Category>(
            future: getItems(item.id,
                limit: 5, fields: fields, filter: filter, sortBy: 'Random'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarousselItem(snapshot.data.items, detailMode: true);
              }
              return Container();
            }));
  }
}
