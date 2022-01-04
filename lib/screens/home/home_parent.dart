import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/bottom_navigation_bar.dart' as bottom_bar;
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/user/user_service.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut/screens/home/components/tablet/drawer.dart' as tablet;
import 'package:jellyflut/screens/home/components/desktop/drawer.dart' as large;

class HomeParent extends StatefulWidget {
  HomeParent({Key? key}) : super(key: key);

  @override
  _HomeParentState createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  late Future<Category> categoryFuture;

  @override
  void initState() {
    categoryFuture = UserService.getLibraryViews();
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
            return responsiveBuilder(snapshot.data!.items);
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error,
                      size: 24, color: Theme.of(context).primaryColor),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget responsiveBuilder(List<Item> items) {
    return ResponsiveBuilder.builder(
        mobile: () => tabsScaffoldMobile(items),
        tablet: () => tabsScaffoldTablet(items),
        desktop: () => tabsScaffoldDesktop(items));
  }

  Widget tabsScaffoldMobile(List<Item> items) {
    return AutoTabsScaffold(
        extendBody: false,
        bottomNavigationBuilder: (tabsContext, _) =>
            bottom_bar.BottomNavigationBar(
                tabsContext: tabsContext, items: items),
        builder: (tabsContext, child, animation) => Row(children: [
              Expanded(child: child),
            ]),
        routes: generateRouteFromItems(items),
        backgroundColor: Theme.of(context).backgroundColor);
  }

  Widget tabsScaffoldTablet(List<Item> items) {
    return AutoTabsScaffold(
        extendBody: true,
        builder: (tabsContext, child, animation) => Row(children: [
              tablet.Drawer(items: items, tabsContext: tabsContext),
              Expanded(child: child)
            ]),
        routes: generateRouteFromItems(items),
        backgroundColor: Theme.of(context).backgroundColor);
  }

  Widget tabsScaffoldDesktop(List<Item> items) {
    return AutoTabsScaffold(
        extendBody: true,
        builder: (tabsContext, child, animation) => Row(children: [
              large.Drawer(items: items, tabsContext: tabsContext),
              Expanded(child: child)
            ]),
        routes: generateRouteFromItems(items),
        backgroundColor: Theme.of(context).backgroundColor);
  }

  /// generate appropriate route for each button
  List<PageRouteInfo<dynamic>> generateRouteFromItems(List<Item> items) {
    final routes = <PageRouteInfo<dynamic>>[];
    //initial route
    routes.add(HomeRoute());
    items.forEach((item) {
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
