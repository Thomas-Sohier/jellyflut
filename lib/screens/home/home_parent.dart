import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/cutsom_drawer.dart';
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
      positionBottom: 80,
      child: FutureBuilder<Category>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AutoTabsScaffold(
                builder: (context, child, animation) {
                  return Scaffold(
                      key: _scaffoldKey,
                      drawer: CustomDrawer(items: snapshot.data?.items),
                      drawerEnableOpenDragGesture: true,
                      drawerEdgeDragWidth:
                          MediaQuery.of(context).size.width * 0.2,
                      appBar: AppBar(actions: [HeaderBar()]),
                      body: child);
                },
                routes:
                    generateRouteFromItems(snapshot.data?.items ?? <Item>[]),
                backgroundColor: Theme.of(context).backgroundColor);
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

  /// generate appropriate route for each button
  List<PageRouteInfo<dynamic>> generateRouteFromItems(final List<Item>? items) {
    final routes = <PageRouteInfo<dynamic>>[];
    final i = items ?? <Item>[];

    //initial route
    routes.add(HomeRoute());
    i.forEach((item) {
      switch (item.collectionType) {
        case CollectionType.LIVETV:
          routes.add(IptvRoute());
          break;
        default:
          routes.add(CollectionRoute(item: item));
      }
    });
    return routes;
  }
}
