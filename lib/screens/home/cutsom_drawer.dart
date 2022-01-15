import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/components/desktop/drawer.dart'
    as personnal_drawer;

class CustomDrawer extends StatelessWidget {
  final List<Item>? items;
  const CustomDrawer({Key? key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child:
            personnal_drawer.Drawer(items: items ?? [], tabsContext: context));
  }
}
