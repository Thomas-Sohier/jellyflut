import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/components/tablet/drawerTabletButton.dart';
import 'package:jellyflut/screens/home/shared/iconNavigationMapper.dart';
import 'package:jellyflut/shared/colors.dart';

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
      color: ColorUtil.lighten(Theme.of(context).backgroundColor, 0.02),
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
        tabsContext: tabsContext, index: 0, icon: Icons.home));
    items.forEach((item) => navBarItems.add(DrawerTabletButton(
        tabsContext: tabsContext,
        index: items.indexOf(item) + 1,
        icon: getRightIconForCollectionType(item.collectionType))));
    return navBarItems;
  }
}
