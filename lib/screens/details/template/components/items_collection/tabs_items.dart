import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/category.dart';

import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab.dart'
    as tab;
import 'package:jellyflut/services/item/item_service.dart';
import 'package:rxdart/rxdart.dart';

class TabsItems extends StatefulWidget {
  final List<Item> items;
  final BehaviorSubject<int>? indexStream;

  TabsItems({Key? key, required this.items, this.indexStream})
      : super(key: key);

  @override
  _TabsItemsState createState() => _TabsItemsState();
}

class _TabsItemsState extends State<TabsItems> {
  late final List<Widget> _widgets;
  late final List<Future<Category>> itemsFutures;

  @override
  void initState() {
    super.initState();
    itemsFutures = <Future<Category>>[];

    final length = widget.items.length;
    widget.items.sort((Item item1, Item item2) =>
        item1.indexNumber?.compareTo(item2.indexNumber ?? length + 1) ??
        length + 1);
    widget.items.forEach((Item i) {
      itemsFutures.add(ItemService.getItems(parentId: i.id));
    });
    _widgets = getTabsChilds(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.indexStream?.stream,
      builder: (c, a) {
        if (a.hasData) {
          return _widgets[a.data ?? 0];
        }
        return const SizedBox();
      },
    );
  }

  List<Widget> getTabsChilds(List<Item> items) {
    final childs = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      final item = items.elementAt(index);
      childs.add(tab.Tab(
        key: ValueKey(item),
        itemsFuture: itemsFutures[index],
        itemPosterHeight: 150,
      ));
    }
    return childs;
  }
}
