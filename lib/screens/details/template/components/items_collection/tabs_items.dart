import 'dart:math';

import 'package:flutter/material.dart';

import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab.dart'
    as tab;

class TabsItems extends StatelessWidget {
  final List<Item> items;
  final TabController? tabController;

  TabsItems({Key? key, required this.items, this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: getTabsChilds(items));
  }

  List<Widget> getTabsChilds(List<Item> items) {
    final childs = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      final item = items.elementAt(index);
      childs.add(tab.Tab(
        item: item,
        itemPosterHeight: 150,
      ));
    }
    return childs;
  }
}
