import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/screens/home/home_drawer_tabs_builder.dart';

import 'home_cubit/home_cubit.dart';

class HomeParent extends StatefulWidget {
  const HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const MusicPlayerFAB(),
        body: BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(itemsRepository: context.read<ItemsRepository>()),
          child: const HomeDrawerTabsBuilder(),
        ));
  }
}
