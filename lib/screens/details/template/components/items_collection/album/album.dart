import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/album/album_header.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/album/cubit/album_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../bloc/details_bloc.dart';
import 'music_item.dart';

class Album extends StatelessWidget {
  const Album({super.key});
  @override
  Widget build(BuildContext context) {
    final item = context.read<DetailsBloc>().state.item;
    if (item.type != ItemType.MusicAlbum) return const SliverToBoxAdapter();
    return BlocProvider(
        create: (context) => AlbumCubit(
              itemsRepository: context.read<ItemsRepository>(),
              item: context.read<DetailsBloc>().state.item,
            ),
        child: const AlbumView());
  }
}

class AlbumView extends StatelessWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case Status.initial:
            case Status.loading:
              return const SongsShimmer();
            case Status.success:
              return const SongsView();
            case Status.failure:
            default:
              return const SliverToBoxAdapter();
          }
        });
  }
}

class SongsView extends StatelessWidget {
  const SongsView({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = context.read<AlbumCubit>().state.songs;
    return MultiSliver(pushPinnedChildren: true, children: [
      const SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: AlbumHeader(),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            return ConstrainedBox(constraints: BoxConstraints(maxHeight: 150), child: MusicItem(item: songs[index]));
          },
          childCount: songs.length,
          addAutomaticKeepAlives: false,
        ),
      ),
    ]);
  }
}

class AlbumError extends StatelessWidget {
  const AlbumError({super.key});

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
          Text('error_loading_item'.tr(args: ['songs'])),
          const SizedBox(height: 8),
          PaletteButton('reload'.tr(), borderRadius: 4, onPressed: () => context.read<AlbumCubit>().retry())
        ],
      ),
    )));
  }
}

class SongsShimmer extends StatelessWidget {
  static const double padding = 12;
  static const double height = 150;
  final int count;
  const SongsShimmer({this.count = 6});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: (height + padding) * count,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                )),
          )),
    );
  }
}
