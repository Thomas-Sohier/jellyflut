import 'package:flutter/material.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
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

class _CollectionParentState extends State<CollectionParent> with HomeTab, TickerProviderStateMixin {
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
    return super.parentBuild(
      child: Stack(children: [
        // if (widget.item.collectionType == CollectionType.movies ||
        //     widget.item.collectionType == CollectionType.books ||
        //     widget.item.collectionType == CollectionType.tvshows)
        //   ChangeNotifierProvider.value(value: carrousselProvider, child: CarrousselBackGroundImage()),

        ListItems.fromCustomRequest(
            fetchMethod: (startIndex, limit) => getItems(startIndex: startIndex, limit: limit),
            verticalListPosterHeight: 250),
      ]),
    );
  }

  Future<List<Item>> getItems({int startIndex = 0, int limit = 100}) async {
    final category = await context.read<ItemsRepository>().getCategory(
        parentId: widget.item.id,
        fields: 'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated,DateAdded,Overview,ChildCount',
        startIndex: startIndex,
        includeItemTypes: widget.item.getCollectionType().map((ItemType e) => e.name).toList().join(','),
        limit: limit);
    return category.items;
  }
}
