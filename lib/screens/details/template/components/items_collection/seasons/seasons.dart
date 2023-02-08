import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'cubit/season_cubit.dart';
import 'season_episode.dart';
import 'tab_header.dart';

class Seasons extends StatelessWidget {
  const Seasons({super.key});
  @override
  Widget build(BuildContext context) {
    final item = context.read<DetailsBloc>().state.item;
    if (item.type != ItemType.Series) return const SliverToBoxAdapter();
    return BlocProvider(
        create: (context) => SeasonCubit(
              itemsRepository: context.read<ItemsRepository>(),
              item: context.read<DetailsBloc>().state.item,
            ),
        child: const SeasonsView());
  }
}

class SeasonsView extends StatelessWidget {
  const SeasonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: const [
      SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: TabHeader(),
      ),
      SeasonEpisode(),
    ]);
  }
}
