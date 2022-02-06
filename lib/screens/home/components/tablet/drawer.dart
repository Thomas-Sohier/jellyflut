import 'package:flutter/material.dart';

import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/components/tablet/drawer_tablet_button.dart';
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
      elevation: 4,
      color: ColorUtil.lighten(Theme.of(context).colorScheme.background, 0.02),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 80),
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView(
              children:
                  createButtonRouteTablet(widget.items, widget.tabsContext)),
        ),
      ),
    );
  }

  List<Widget> createButtonRouteTablet(
      List<Item> items, BuildContext tabsContext) {
    final navBarItems = <Widget>[];
    //initial route
    navBarItems.add(DrawerTabletButton(
        tabsContext: tabsContext, index: 0, icon: Icons.home_outlined));
    items.forEach((item) => navBarItems.add(DrawerTabletButton(
        tabsContext: tabsContext,
        index: items.indexOf(item) + 1,
        icon: getRightIconForCollectionType(item.collectionType))));
    return navBarItems;
  }
}
