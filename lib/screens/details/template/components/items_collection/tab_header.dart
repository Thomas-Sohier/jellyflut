import 'package:jellyflut/screens/details/template/components/items_collection/cubit/collection_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:universal_io/io.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

const _height = 80.0;

class TabHeader extends SliverPersistentHeaderDelegate {
  final EdgeInsets padding;

  const TabHeader({Key? key, this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    context.read<DetailsBloc>().add(PinnedHeaderChangeRequested(shrinkOffset: shrinkOffset));
    return BlocConsumer<CollectionCubit, CollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.status) {
          case CollectionStatus.initial:
          case CollectionStatus.loading:
            return ShimmerHeaderBar(padding: padding);
          case CollectionStatus.success:
            return HeaderBar(padding: padding);
          default:
            return const SizedBox(height: _height);
        }
      },
    );
  }

  Widget safeAreaBuilder(Widget child) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(child: child);
    }
    return child;
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

class ShimmerHeaderBar extends StatelessWidget {
  static const EdgeInsets buttonPadding = EdgeInsets.only(right: 12);
  static const double height = 50;
  static const double width = 150;
  static const int count = 4;
  final EdgeInsets padding;

  const ShimmerHeaderBar({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SizedBox(
          height: _height,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.background.withAlpha(150),
            highlightColor: Theme.of(context).colorScheme.background.withAlpha(100),
            child: BlocBuilder<DetailsBloc, DetailsState>(
                buildWhen: (previous, current) => previous.pinnedHeader != current.pinnedHeader,
                builder: (_, state) => AnimatedPadding(
                      padding: state.pinnedHeader ? padding.copyWith(left: padding.left + 40) : padding,
                      duration: Duration(milliseconds: 200),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: count,
                          itemExtent: (width + buttonPadding.right),
                          itemBuilder: (context, index) {
                            return Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: buttonPadding,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      child: SizedBox(
                                          height: height,
                                          width: double.infinity,
                                          child: ColoredBox(
                                            color: Theme.of(context).colorScheme.background.withAlpha(150),
                                          ))),
                                ));
                          }),
                    )),
          )),
    ));
  }
}

class HeaderBar extends StatelessWidget {
  final EdgeInsets padding;

  const HeaderBar({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final seasons = context.read<CollectionCubit>().seasons;
    return ClipRRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SizedBox(
          height: _height,
          child: BlocBuilder<DetailsBloc, DetailsState>(
            buildWhen: (previous, current) => previous.pinnedHeader != current.pinnedHeader,
            builder: (_, state) => AnimatedPadding(
                padding: state.pinnedHeader ? padding.copyWith(left: padding.left + 40) : padding,
                duration: Duration(milliseconds: 200),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasons.length,
                    itemBuilder: (context, index) {
                      return HeaderButton(item: seasons[index]);
                    })),
          )),
    ));
  }
}

class HeaderButton extends StatelessWidget {
  final Item item;
  const HeaderButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: PaletteButton(
        item.name ?? '',
        onPressed: () => context.read<CollectionCubit>().goToSeason(item),
        borderRadius: 4,
        maxHeight: 50,
        minWidth: 40,
        maxWidth: 150,
      ),
    );
  }
}
