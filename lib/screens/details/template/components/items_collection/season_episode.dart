import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:shimmer/shimmer.dart';

import '../collection.dart';
import 'cubit/collection_cubit.dart';

class SeasonEpisode extends StatelessWidget {
  const SeasonEpisode({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionCubit = context.read<CollectionCubit>();
    return BlocConsumer<CollectionCubit, CollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.status) {
          case CollectionStatus.failure:
            return const SeasonEpisodeError();
          case CollectionStatus.loading:
            return const EpisodesShimmer();
          case CollectionStatus.initial:
          case CollectionStatus.success:
            if (collectionCubit.seasons.isNotEmpty) {
              return Collection(collectionCubit.item, seasons: collectionCubit.seasons);
            }
            return const SeasonEpisodeEmpty();
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class SeasonEpisodeError extends StatelessWidget {
  const SeasonEpisodeError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Icon(Icons.error_outline),
          const SizedBox(height: 4),
          Text('error_loading_item'.tr(args: ['episodes'])),
          const SizedBox(height: 8),
          PaletteButton('reload'.tr(), borderRadius: 4, onPressed: () => context.read<CollectionCubit>().retry())
        ],
      ),
    ));
  }
}

class SeasonEpisodeEmpty extends StatelessWidget {
  const SeasonEpisodeEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Icon(Icons.folder_open_outlined),
          const SizedBox(height: 4),
          Text('empty_collection'.tr()),
          const SizedBox(height: 8),
          PaletteButton('reload'.tr(), borderRadius: 4, onPressed: () => context.read<CollectionCubit>().retry())
        ],
      ),
    ));
  }
}

class EpisodesShimmer extends StatelessWidget {
  static const double padding = 12;
  static const double height = 150;
  final int count;
  const EpisodesShimmer({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (height + padding) * count,
        child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.background.withAlpha(150),
            highlightColor: Theme.of(context).colorScheme.background.withAlpha(100),
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
            )));
  }
}
