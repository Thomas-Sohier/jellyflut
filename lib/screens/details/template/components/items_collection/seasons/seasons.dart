import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details/details_ui_model.dart';
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
    return BlocProvider.value(value: context.read<SeasonCubit>(), child: const SeasonsView());
  }
}

class SeasonsView extends StatelessWidget {
  const SeasonsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.select((DetailsUIModel model) => model.layout.isMobile);

    return MultiSliver(
      children: [
        SliverPersistentHeader(pinned: true, floating: false, delegate: TabHeader(isMobile: isMobile)),
        const SeasonEpisode(),
      ],
    );
  }
}
