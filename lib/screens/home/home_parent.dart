import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/screens/home/home_drawer_tabs_builder.dart';

import 'cubit/home_cubit.dart';

class HomeParent extends StatelessWidget {
  const HomeParent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: MusicPlayerFAB(),
        body: BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(itemsRepository: context.read<ItemsRepository>()),
          child: const HomeDrawerTabsBuilder(),
        ));
  }
}
