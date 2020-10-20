import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/components/carrousselBackGroundImage.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/collection/listItems.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:jellyflut/shared/shared.dart';

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
  int pageCount = 1;
  var items = <Item>[];
  var itemsToShow = <Item>[];
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
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
    final item = ModalRoute.of(context).settings.arguments as Item;
    return Scaffold(
        floatingActionButton: MusicPlayerFAB(),
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (item.collectionType == 'movies' || item.collectionType == 'books')
            CarrousselBackGroundImage(),
          Positioned(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      if (item.collectionType == 'movies' ||
                          item.collectionType == 'books')
                        head(item, context),
                      listOfItems(item),
                    ],
                  )))
        ])));
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      showMoreItem();
    }
  }

  void showMoreItem() {
    if (items.isEmpty) return;
    var startIndex = (pageCount - 1) * 10;
    var endIndex =
        items.length > pageCount * 10 ? pageCount * 10 : items.length;
    if (startIndex > endIndex) return;
    var _items = items.sublist(startIndex, endIndex);
    ListOfItems().addNewItems(_items);
    pageCount++;
  }

  Widget listOfItems(Item item) {
    return FutureBuilder<Category>(
        future: getItems(item.id,
            filter: '',
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

  Widget head(Item item, BuildContext context) {
    var size = MediaQuery.of(context).size;
    var filter = 'IsNotFolder,IsUnplayed';
    var fields =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview';

    return Container(
        padding: EdgeInsets.only(top: size.height * 0.02),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: FutureBuilder<Category>(
                future: getItems(item.id,
                    limit: 5, fields: fields, filter: filter, sortBy: 'Random'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarousselItem(snapshot.data.items, detailMode: true);
                  }
                  return Container();
                })));
  }
}
