import 'package:flutter/material.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/home/home_drawer_tabs_builder.dart';
import 'package:jellyflut/screens/home/offline_screen.dart';
import 'package:jellyflut/services/user/user_service.dart';

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
    return Scaffold(
      floatingActionButton: MusicPlayerFAB(),
      body: FutureBuilder<Category>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data?.items ?? <Item>[];
            return HomeDrawerTabsBuilder(items: items);
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
}
