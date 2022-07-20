import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/season_episode.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'tab_header.dart';

class Seasons extends StatelessWidget {
  const Seasons({super.key});

  @override
  Widget build(BuildContext context) {
    final item = context.read<DetailsBloc>().state.item;
    if (item.type != ItemType.Series) return const SliverToBoxAdapter();
    return MultiSliver(children: [
      const SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: TabHeader(),
      ),
      const SeasonEpisode(),
    ]);
  }
}
