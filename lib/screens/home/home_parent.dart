import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/bottom_navigation_bar.dart' as bottom_bar;
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/user/user_service.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut/screens/home/components/desktop/drawer.dart' as large;
import 'package:jellyflut/screens/home/components/tablet/drawer.dart' as tablet;

class HomeParent extends StatefulWidget {
  HomeParent({Key? key}) : super(key: key);

  @override
  _HomeParentState createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  late Future<Category> categoryFuture;

  @override
  void initState() {
    categoryFuture = UserService.getLibraryCategory();
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
          return Container();
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
        routes: generateRouteFromItems(items),
        bottomNavigationBuilder: (context, tabsRouter) =>
            bottom_bar.BottomNavigationBar(
                tabsRouter: tabsRouter, items: items),
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

  List<PageRouteInfo<dynamic>> generateRouteFromItems(List<Item> items) {
    final routes = <PageRouteInfo<dynamic>>[];
    //initial route
    routes.add(HomeRoute());
    items.forEach((item) {
      routes.add(CollectionRoute(item: item));
    });
    return routes;
  }
}
