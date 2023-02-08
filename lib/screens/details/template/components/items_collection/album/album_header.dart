import 'package:jellyflut/screens/details/template/components/items_collection/album/cubit/album_cubit.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _height = 38.0;

class AlbumHeader extends SliverPersistentHeaderDelegate {
  const AlbumHeader({Key? key});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final title = context.read<AlbumCubit>().state.songs.first.name;
    return DiscTitle(title: title ?? 'Title here');
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class DiscTitle extends StatelessWidget {
  final String title;

  const DiscTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.album, color: Theme.of(context).colorScheme.onBackground),
          const SizedBox(width: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class ShimmerHeaderBar extends StatelessWidget {
  const ShimmerHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: _height,
        child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.background.withAlpha(150),
            highlightColor: Theme.of(context).colorScheme.background.withAlpha(100),
            child: const SizedBox.expand()));
  }
}
