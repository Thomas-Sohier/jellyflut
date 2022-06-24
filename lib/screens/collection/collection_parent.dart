import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'package:provider/provider.dart';

class CollectionParent extends StatefulWidget {
  final Item item;

  const CollectionParent({super.key, required this.item});

  @override
  State<StatefulWidget> createState() {
    return _CollectionParentState();
  }
}

class _CollectionParentState extends State<CollectionParent>
    with HomeTab, TickerProviderStateMixin {
  late final CarrousselProvider carrousselProvider;

  @override
  set tabController(TabController tabController) {
    super.tabController = tabController;
  }

  @override
  void initState() {
    carrousselProvider = CarrousselProvider();
    tabController = TabController(length: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: excluding,
      child: Stack(children: [
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
      ]),
    );
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
            .map((ItemType e) => e.value)
            .toList()
            .join(','),
        limit: limit);
  }
}
