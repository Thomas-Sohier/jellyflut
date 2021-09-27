import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/components/desktop/drawer_large_button.dart';
import 'package:jellyflut/screens/home/shared/icon_navigation_mapper.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class Drawer extends StatefulWidget {
  final List<Item> items;
  final BuildContext tabsContext;
  Drawer({Key? key, required this.items, required this.tabsContext})
      : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 6,
        color: ColorUtil.lighten(Theme.of(context).backgroundColor, 0.02),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: ListView(
              children:
                  createButtonRouteDesktop(widget.items, widget.tabsContext)),
        ));
  }

  List<Widget> createButtonRouteDesktop(
      List<Item> items, BuildContext tabsContext) {
    final navBarItems = <Widget>[];
    //initial route
    navBarItems.add(DrawerLargeButton(
        tabsContext: tabsContext,
        name: 'Home',
        index: 0,
        icon: Icons.home_outlined));
    items.forEach((item) => navBarItems.add(DrawerLargeButton(
        tabsContext: tabsContext,
        index: items.indexOf(item) + 1,
        name: item.name,
        icon: getRightIconForCollectionType(item.collectionType))));
    return navBarItems;
  }
}
