import 'package:flutter/material.dart';
import 'package:jellyflut/screens/home/shared/icon_navigation_mapper.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'drawer_large_button.dart';

class CutsomDrawer extends StatefulWidget {
  final List<Item> items;
  CutsomDrawer({super.key, required this.items});

  @override
  State<CutsomDrawer> createState() => _CutsomDrawerState();
}

class _CutsomDrawerState extends State<CutsomDrawer> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(controller: _scrollController, children: createButtonRouteDesktop(widget.items)),
    );
  }

  List<Widget> createButtonRouteDesktop(List<Item> items) {
    final navBarItems = <Widget>[];
    //initial route
    navBarItems.add(DrawerLargeButton(name: 'Home', index: 0, icon: Icons.home_outlined));
    for (var item in items) {
      navBarItems.add(DrawerLargeButton(
          index: items.indexOf(item) + 1,
          name: item.name ?? '',
          icon: getRightIconForCollectionType(item.collectionType)));
    }
    return navBarItems;
  }
}
