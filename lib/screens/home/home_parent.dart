import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/custom_drawer.dart';
import 'package:jellyflut/screens/home/offline_screen.dart';
import 'package:jellyflut/services/user/user_service.dart';

import 'header_bar.dart';

class HomeParent extends StatefulWidget {
  HomeParent({Key? key}) : super(key: key);

  @override
  _HomeParentState createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  late Future<Category> categoryFuture;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    categoryFuture = UserService.getLibraryViews();
    _scaffoldKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayerFAB(
      positionBottom: 20,
      child: FutureBuilder<Category>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data?.items;
            return homeTabs(items);
          } else if (snapshot.hasError) {
            return OffLineScreen(
                error: snapshot.error,
                reloadFunction: () {
                  setState(() {
                    categoryFuture = UserService.getLibraryViews();
                  });
                });
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget homeTabs(final List<Item>? items) {
    return AutoTabsScaffold(
        routes: generateRouteFromItems(items ?? <Item>[]),
        builder: (context, child, animation) {
          return Scaffold(
              drawer: CustomDrawer(items: items),
              backgroundColor: Theme.of(context).colorScheme.background,
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
