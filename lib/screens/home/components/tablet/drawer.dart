import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/collectionType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/components/tablet/drawerTabletButton.dart';

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
      color: Theme.of(context).backgroundColor,
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
        icon: getRightIconForType(item.collectionType))));
    return navBarItems;
  }

  IconData getRightIconForType(CollectionType? collectionType) {
    switch (collectionType) {
      case CollectionType.BOOKS:
        return Icons.book;
      case CollectionType.TVSHOWS:
        return Icons.tv;
      case CollectionType.BOXSETS:
        return Icons.account_box;
      case CollectionType.MOVIES:
        return Icons.movie;
      case CollectionType.MUSIC:
        return Icons.music_note;
      case CollectionType.HOMEVIDEOS:
        return Icons.video_camera_back;
      case CollectionType.MUSICVIDEOS:
        return Icons.music_video;
      case CollectionType.MIXED:
        return Icons.blender;
      default:
        return Icons.tv;
    }
  }
}
