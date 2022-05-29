import 'package:flutter/material.dart';

import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart' as globals;

class Tab extends StatefulWidget {
  final Future<Category> itemsFuture;
  final double? itemPosterHeight;

  Tab({super.key, required this.itemsFuture, this.itemPosterHeight});

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<Tab> with AutomaticKeepAliveClientMixin {
  late double itemPosterHeight;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    itemPosterHeight = widget.itemPosterHeight ?? globals.itemPosterHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListItems.fromFuture(
        itemsFuture: widget.itemsFuture,
        listType: ListType.LIST,
        verticalListPosterHeight: 150,
        physics: NeverScrollableScrollPhysics(),
        showIfEmpty: false,
        showTitle: false,
        showSorting: false);
  }
}
