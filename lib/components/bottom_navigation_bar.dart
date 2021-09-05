import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
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
        child: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          final maxNbItems = (constraints.maxWidth / 60).round() - 1;
          if (maxNbItems <= widget.items.length) {
            return SizedBox(
              height: 60,
              child: SizedBox(
                width: constraints.maxWidth,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      SalomonBottomBar(
                          currentIndex: widget.tabsRouter.activeIndex,
                          onTap: (index) => setState(() {
                                widget.tabsRouter.setActiveIndex(index);
                              }),
                          items: createButtonRoute(widget.items)),
                    ]),
              ),
            );
          }
          return SalomonBottomBar(
              currentIndex: widget.tabsRouter.activeIndex,
              onTap: (index) => setState(() {
                    widget.tabsRouter.setActiveIndex(index);
                  }),
              items: createButtonRoute(widget.items));
        })));
  }

  List<SalomonBottomBarItem> createButtonRoute(List<Item> items) {
    final navBarItems = <SalomonBottomBarItem>[];
    //initial route
    navBarItems.add(SalomonBottomBarItem(
        icon: Icon(Icons.home_outlined),
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
        return Icons.book_outlined;
      case CollectionType.TVSHOWS:
        return Icons.tv_outlined;
      case CollectionType.BOXSETS:
        return Icons.account_box_outlined;
      case CollectionType.MOVIES:
        return Icons.movie_outlined;
      case CollectionType.MUSIC:
        return Icons.music_note_outlined;
      case CollectionType.HOMEVIDEOS:
        return Icons.video_camera_back_outlined;
      case CollectionType.MUSICVIDEOS:
        return Icons.music_video_outlined;
      case CollectionType.MIXED:
        return Icons.blender_outlined;
      default:
        return Icons.tv;
    }
  }
}
