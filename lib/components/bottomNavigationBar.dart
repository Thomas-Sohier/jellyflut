import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/collectionType.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationBar extends StatefulWidget {
  final TabsRouter tabsRouter;
  final List<Item> items;

  BottomNavigationBar({Key? key, required this.tabsRouter, required this.items})
      : super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).backgroundColor,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: SafeArea(
          child: SalomonBottomBar(
              currentIndex: widget.tabsRouter.activeIndex,
              onTap: (index) => setState(() {
                    widget.tabsRouter.setActiveIndex(index);
                  }),
              items: createButtonRoute(widget.items)),
        ));
  }

  List<SalomonBottomBarItem> createButtonRoute(List<Item> items) {
    final navBarItems = <SalomonBottomBarItem>[];
    //initial route
    navBarItems.add(SalomonBottomBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
        selectedColor: Theme.of(context).accentColor,
        unselectedColor: Theme.of(context).primaryColor));
    items.forEach((item) {
      navBarItems.add(SalomonBottomBarItem(
          icon: Icon(getRightIconForType(item.collectionType)),
          title: Text(item.name),
          selectedColor: Theme.of(context).accentColor,
          unselectedColor: Theme.of(context).primaryColor));
    });
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
