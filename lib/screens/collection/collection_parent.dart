import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:provider/provider.dart';

class CollectionParent extends StatefulWidget {
  final Item item;

  const CollectionParent({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CollectionParentState();
  }
}

class _CollectionParentState extends State<CollectionParent>
    with AutoRouteAware {
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          if (widget.item.collectionType == CollectionType.MOVIES ||
              widget.item.collectionType == CollectionType.BOOKS ||
              widget.item.collectionType == CollectionType.TVSHOWS)
            ChangeNotifierProvider.value(
                value: carrousselProvider, child: CarrousselBackGroundImage()),
          ListItems.fromFuture(
              itemsFuture: getItems(item: widget.item),
              verticalListPosterHeight: 250,
              loadMoreFunction: (int startIndex, int numberOfItemsToLoad) =>
                  getItems(
                      item: widget.item,
                      startIndex: startIndex,
                      limit: numberOfItemsToLoad),
              listType: ListType.GRID),
        ]));
  }

  Future<Category> getItems(
      {required Item item, int startIndex = 0, int limit = 100}) async {
    return ItemService.getItems(
        parentId: item.id,
        sortBy: 'SortName',
        fields:
            'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated,DateAdded,Overview,ChildCount',
        imageTypeLimit: 1,
        recursive: false,
        startIndex: startIndex,
        includeItemTypes: item
            .getCollectionType()
            .map((ItemType e) => e.getValue())
            .toList()
            .join(','),
        limit: limit);
  }
}
