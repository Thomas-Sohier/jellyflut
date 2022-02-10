import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';

import 'custom_drawer.dart';
import 'header_bar.dart';

class HomeDrawerTabsBuilder extends StatefulWidget {
  final List<Item> items;
  HomeDrawerTabsBuilder({Key? key, required this.items}) : super(key: key);

  @override
  State<HomeDrawerTabsBuilder> createState() => _HomeDrawerTabsBuilderState();
}

class _HomeDrawerTabsBuilderState extends State<HomeDrawerTabsBuilder> {
  late final List<Item> items;
  late final List<PageRouteInfo<dynamic>> routes;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    items = widget.items;
    routes = generateRouteFromItems(items);
    _scaffoldKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        routes: routes,
        builder: (context, child, animation) {
          return Scaffold(
              drawer: CustomDrawer(items: items),
              key: _scaffoldKey,
              drawerEnableOpenDragGesture: true,
              drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
              appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  actions: [HeaderBar()]),
              body: child);
        });
  }

  /// generate appropriate route for each button
  List<PageRouteInfo<dynamic>> generateRouteFromItems(final List<Item>? items) {
    final routes = <PageRouteInfo<dynamic>>[];
    final i = items ?? <Item>[];

    //initial route
    routes.add(HomeRoute(key: UniqueKey()));
    i.forEach((item) {
      switch (item.collectionType) {
        case CollectionType.LIVETV:
          routes.add(IptvRoute(key: UniqueKey()));
          break;
        default:
          routes.add(CollectionRoute(key: ValueKey(item), item: item));
      }
    });
    return routes;
  }
}
