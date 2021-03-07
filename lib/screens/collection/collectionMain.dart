import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/carrousselModel.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/collection/listItems.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:provider/provider.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';

class CollectionMain extends StatefulWidget {
  final Item item;

  const CollectionMain({@required this.item});

  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

class _CollectionMainState extends State<CollectionMain> {
  var items = <Item>[];
  var itemsToShow = <Item>[];

  // Provider
  ListOfItems listOfItems;
  CarrousselModel carrousselModel;

  @override
  void initState() {
    super.initState();
    listOfItems = ListOfItems();
    carrousselModel = CarrousselModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var headerHeight = 64.toDouble();
    listOfItems.setParentItem(widget.item.id);
    listOfItems.setTypeOfItems([widget.item.getCollectionType()]);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (widget.item.collectionType == 'movies' ||
              widget.item.collectionType == 'books')
            ChangeNotifierProvider.value(
                value: carrousselModel, child: CarrousselBackGroundImage()),
          ChangeNotifierProvider.value(
              value: listOfItems,
              child: ListItems(headerBarHeight: headerHeight)),
          DetailHeaderBar(
            color: Colors.white,
            height: headerHeight,
          ),
        ])));
  }
}
