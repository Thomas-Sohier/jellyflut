import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/tab.dart'
    as tab;

class TabsItems extends StatefulWidget {
  final List<Item> items;

  TabsItems({Key? key, required this.items}) : super(key: key);

  @override
  _TabsItemsState createState() => _TabsItemsState();
}

class _TabsItemsState extends State<TabsItems>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  AxisDirection direction = AxisDirection.left;

  @override
  void initState() {
    tabController = TabController(length: widget.items.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return tabs(widget.items);
  }

  Widget tabs(List<Item> items) {
    final height = MediaQuery.of(context).size.height;
    final tabHeight = height < 800 ? 800 : height;
    return DefaultTabController(
      length: items.length,
      initialIndex: 0,
      child: SizedBox(
        height: tabHeight.toDouble(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: getTabsHeader(items),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: getTabsChilds(items),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getTabsHeader(List<Item> items) {
    final headers = <Widget>[];
    items.forEach(
        (Item item) => headers.add(tabHeader(item, items.indexOf(item))));
    return headers;
  }

  Widget tabHeader(Item item, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Flexible(
        child: PaletteButton(
          item.name,
          onPressed: () => tabController.animateTo(index),
          borderRadius: 4,
          minWidth: 40,
          maxWidth: 150,
        ),
      ),
    );
  }

  List<Widget> getTabsChilds(List<Item> items) {
    final childs = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      final item = items.elementAt(index);
      childs.add(tab.Tab(item: item));
    }
    return childs;
  }
}
