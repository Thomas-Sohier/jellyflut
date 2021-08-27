import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/collectionType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
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
  late final CarrousselProvider carrousselProvider;

  @override
  void initState() {
    super.initState();
    carrousselProvider = CarrousselProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var headerHeight = 64.toDouble();

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (widget.item.collectionType == CollectionType.MOVIES ||
              widget.item.collectionType == CollectionType.BOOKS ||
              widget.item.collectionType == CollectionType.TVSHOWS)
            ChangeNotifierProvider.value(
                value: carrousselProvider, child: CarrousselBackGroundImage()),
          ListItems(headerBarHeight: headerHeight, parentItem: widget.item),
          if (customRouter.canPopSelfOrChildren)
            DetailHeaderBar(
              color: Colors.white,
              height: headerHeight,
            ),
        ])));
  }
}
