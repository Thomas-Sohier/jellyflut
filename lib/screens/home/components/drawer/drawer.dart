import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/shared/icon_navigation_mapper.dart';
import 'drawer_large_button.dart';

class Drawer extends StatefulWidget {
  final List<Item> items;
  Drawer({Key? key, required this.items}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
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
    return ListView(
        controller: _scrollController,
        children: createButtonRouteDesktop(widget.items));
  }

  List<Widget> createButtonRouteDesktop(List<Item> items) {
    final navBarItems = <Widget>[];
    //initial route
    navBarItems.add(
        DrawerLargeButton(name: 'Home', index: 0, icon: Icons.home_outlined));
    items.forEach((item) => navBarItems.add(DrawerLargeButton(
        index: items.indexOf(item) + 1,
        name: item.name,
        icon: getRightIconForCollectionType(item.collectionType))));
    return navBarItems;
  }
}
