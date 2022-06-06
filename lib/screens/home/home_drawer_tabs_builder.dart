import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/home/home_tabs_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/components/drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'header_bar.dart';

class HomeDrawerTabsBuilder extends StatefulWidget {
  final List<Item> items;
  HomeDrawerTabsBuilder({super.key, required this.items});

  @override
  State<HomeDrawerTabsBuilder> createState() => _HomeDrawerTabsBuilderState();
}

class _HomeDrawerTabsBuilderState extends State<HomeDrawerTabsBuilder> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final List<PageRouteInfo<dynamic>> routes;
  late final List<Item> items;
  late final HomeTabsProvider _homeTabsProvider;

  @override
  void initState() {
    items = widget.items;
    routes = generateRouteFromItems(items);
    _scaffoldKey = GlobalKey();
    _homeTabsProvider = HomeTabsProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        scaffoldKey: _scaffoldKey,
        drawer: CutsomDrawer(items: items),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2,
        routes: routes,
        appBarBuilder: (_, __) => AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            flexibleSpace: HeaderBar(),
            bottom: tabbar()),
        builder: (context, child, animation) {
          return PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> _,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: Theme.of(context).colorScheme.background,
                child: child,
              );
            },
            child: child,
          );
        });
  }

  /// generate appropriate route for each button
  List<PageRouteInfo<dynamic>> generateRouteFromItems(final List<Item>? items) {
    final routes = <PageRouteInfo<dynamic>>[];
    final i = items ?? <Item>[];

    //initial route
    routes.add(HomeRoute(key: UniqueKey()));
    for (var item in i) {
      switch (item.collectionType) {
        case CollectionType.LIVETV:
          routes.add(IptvRoute(key: UniqueKey()));
          break;
        default:
          routes.add(CollectionRoute(key: ValueKey(item), item: item));
      }
    }
    return routes;
  }

  PreferredSizeWidget? tabbar() {
    if (_homeTabsProvider.getTabs.isNotEmpty) {
      return PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Consumer<HomeTabsProvider>(
              builder: (_, provider, ___) => TabBar(
                  controller: provider.getTabController,
                  tabs: provider.getTabs)));
    }
    return null;
  }
}
