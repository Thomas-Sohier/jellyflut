import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/components/episode_item.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'cubit/season_cubit.dart';

class SeasonEpisode extends StatelessWidget {
  const SeasonEpisode({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionCubit = context.read<SeasonCubit>();
    return BlocBuilder<SeasonCubit, SeasonState>(
      buildWhen: (previous, current) =>
          previous.epsiodesStatus != current.epsiodesStatus || previous.currentEpisodes != current.currentEpisodes,
      builder: (context, state) {
        switch (state.epsiodesStatus) {
          case Status.failure:
            return const SeasonEpisodeError();
          case Status.loading:
            return const EpisodesShimmer();
          case Status.initial:
          case Status.success:
            if (collectionCubit.state.currentSeason.isNotEmpty) {
              final episodes = context.read<SeasonCubit>().state.currentEpisodes;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 250), child: EpisodeItem(item: episodes[index]));
                  },
                  childCount: episodes.length,
                  addAutomaticKeepAlives: false,
                ),
              );
            }

            // return Collection(collectionCubit.item, seasons: collectionCubit.seasons);
            return const SeasonEpisodeEmpty();
          default:
            return const SliverToBoxAdapter();
        }
      },
    );
  }
}

class SeasonEpisodeError extends StatelessWidget {
  const SeasonEpisodeError({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Icon(Icons.error_outline),
          const SizedBox(height: 4),
          Text('error_loading_item'.tr(args: ['episodes'])),
          const SizedBox(height: 8),
          PaletteButton('reload'.tr(), borderRadius: 4, onPressed: () => context.read<SeasonCubit>().retry())
        ],
      ),
    )));
  }
}

class SeasonEpisodeEmpty extends StatelessWidget {
  const SeasonEpisodeEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Icon(Icons.folder_open_outlined),
          const SizedBox(height: 4),
          Text('empty_collection'.tr()),
          const SizedBox(height: 8),
          PaletteButton('reload'.tr(), borderRadius: 4, onPressed: () => context.read<SeasonCubit>().retry())
        ],
      ),
    )));
  }
}

class EpisodesShimmer extends StatelessWidget {
  static const double padding = 12;
  static const double height = 150;
  final int count;
  const EpisodesShimmer({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: context.read<DetailsBloc>().state.contentPadding,
      sliver: SliverToBoxAdapter(
        child: SizedBox(
            height: (height + padding) * count,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                highlightColor: Theme.of(context).colorScheme.onBackground.withAlpha(100),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemExtent: height + padding,
                      itemCount: count,
                      itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(top: padding),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                child: Container(
                                  height: height,
                                  width: double.infinity,
                                  color: Theme.of(context).colorScheme.background.withAlpha(150),
                                )),
                          )),
                ))),
      ),
    );
  }
}
