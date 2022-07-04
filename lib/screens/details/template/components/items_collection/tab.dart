import 'package:flutter/material.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart' as globals;
import 'package:jellyflut_models/jellyflut_models.dart';

class Tab extends StatefulWidget {
  final List<Item> items;
  final double? itemPosterHeight;

  const Tab({super.key, required this.items, this.itemPosterHeight});

  @override
  State<Tab> createState() => _TabState();
}

class _TabState extends State<Tab> with AutomaticKeepAliveClientMixin {
  double get itemPosterHeight => widget.itemPosterHeight ?? globals.itemPosterHeight;
  List<Item> get items => widget.items;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListItems.fromList(
        category: Category(items: items, totalRecordCount: items.length, startIndex: 0),
        listType: ListType.LIST,
        verticalListPosterHeight: itemPosterHeight,
        physics: NeverScrollableScrollPhysics(),
        showIfEmpty: false,
        showTitle: false,
        showSorting: false);
  }
}
