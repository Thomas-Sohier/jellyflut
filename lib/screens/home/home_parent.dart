import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/screens/home/home_drawer_tabs_builder.dart';
import 'package:jellyflut/screens/home/offline_screen.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class HomeParent extends StatefulWidget {
  HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  late Future<Category> categoryFuture;

  @override
  void initState() {
    categoryFuture = context.read<ItemsRepository>().getLibraryViews();

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
                error: snapshot.error as Error?,
                reloadFunction: () {
                  setState(() {
                    categoryFuture = context.read<ItemsRepository>().getLibraryViews();
                  });
                });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
