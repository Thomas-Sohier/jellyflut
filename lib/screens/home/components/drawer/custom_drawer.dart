import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'drawer.dart' as personnal_drawer;

class CustomDrawer extends StatelessWidget {
  final List<Item>? items;
  const CustomDrawer({Key? key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(child: personnal_drawer.Drawer(items: items ?? []));
  }
}
