import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/screens/collection/list_items.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:provider/provider.dart';
import 'package:jellyflut/screens/details/detail_header_bar.dart';

class CollectionParent extends StatefulWidget {
  final Item item;

  const CollectionParent({required this.item});

  @override
  State<StatefulWidget> createState() {
    return _CollectionParentState();
  }
}

class _CollectionParentState extends State<CollectionParent> {
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
