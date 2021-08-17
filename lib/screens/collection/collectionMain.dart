import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
import 'package:jellyflut/providers/items/itemsProvider.dart';
import 'package:jellyflut/screens/collection/listItems.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:provider/provider.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';

class CollectionMain extends StatefulWidget {
  final Item item;

  const CollectionMain({required this.item});

  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

class _CollectionMainState extends State<CollectionMain> {
  // Provider
  late final ItemsProvider itemsProvider;
  late final CarrousselProvider carrousselProvider;

  @override
  void initState() {
    super.initState();
    itemsProvider = ItemsProvider();
    carrousselProvider = CarrousselProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var headerHeight = 64.toDouble();
    itemsProvider.setParentItem(widget.item.id);
    itemsProvider.setTypeOfItems([widget.item.getCollectionType()]);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (widget.item.collectionType == 'movies' ||
              widget.item.collectionType == 'books')
            ChangeNotifierProvider.value(
                value: carrousselProvider, child: CarrousselBackGroundImage()),
          ChangeNotifierProvider.value(
              value: itemsProvider,
              child: ListItems(headerBarHeight: headerHeight)),
          DetailHeaderBar(
            color: Colors.white,
            height: headerHeight,
          ),
        ])));
  }
}
