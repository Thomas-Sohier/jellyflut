import 'package:jellyflut/components/subtree_builder.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:universal_io/io.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

import 'cubit/season_cubit.dart';

const _height = 80.0;

class TabHeader extends SliverPersistentHeaderDelegate {
  final EdgeInsets padding;

  const TabHeader({Key? key, this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    context.read<DetailsBloc>().add(PinnedHeaderChangeRequested(shrinkOffset: shrinkOffset));
    return BlocBuilder<SeasonCubit, SeasonState>(
      buildWhen: (previous, current) => previous.seasonStatus != current.seasonStatus,
      builder: (context, state) {
        switch (state.seasonStatus) {
          case Status.initial:
          case Status.loading:
            return ShimmerHeaderBar(padding: padding);
          case Status.success:
            return HeaderBar(padding: padding);
          case Status.failure:
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
    return SubtreeBuilder(
      builder: (_, child) => BlocBuilder<DetailsBloc, DetailsState>(
          buildWhen: (previous, current) => previous.pinnedHeader != current.pinnedHeader,
          builder: (_, state) => _HeaderBlur(
              pinnedHeader: state.pinnedHeader,
              child: SizedBox(
                  height: _height,
                  child: Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                      highlightColor: Theme.of(context).colorScheme.onBackground.withAlpha(100),
                      child: AnimatedPadding(
                          padding: state.pinnedHeader ? padding.copyWith(left: padding.left + 40) : padding,
                          duration: Duration(milliseconds: 200),
                          child: child ?? const SizedBox()))))),
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
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                          ))),
                ));
          }),
    );
  }
}

class HeaderBar extends StatelessWidget {
  final EdgeInsets padding;

  const HeaderBar({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
        buildWhen: (previous, current) =>
            previous.pinnedHeader != current.pinnedHeader || previous.screenLayout != current.screenLayout,
        builder: (_, state) => _HeaderBlur(
            pinnedHeader: state.pinnedHeader,
            child: SizedBox(
                height: _height,
                child: AnimatedPadding(
                    padding: state.pinnedHeader && state.screenLayout.isMobile
                        ? padding.copyWith(left: padding.left + 40)
                        : padding,
                    duration: Duration(milliseconds: 200),
                    child: _HeaderSeasonsButtons()))));
  }
}

class _HeaderSeasonsButtons extends StatelessWidget {
  const _HeaderSeasonsButtons();

  @override
  Widget build(BuildContext context) {
    final seasons = context.read<SeasonCubit>().state.seasons;
    return BlocBuilder<SeasonCubit, SeasonState>(
        buildWhen: (previous, current) => previous.currentSeason != current.currentSeason,
        builder: (_, state) => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              return HeaderButton(item: seasons[index]);
            }));
  }
}

class _HeaderBlur extends StatelessWidget {
  final Widget child;
  final bool pinnedHeader;
  const _HeaderBlur({required this.child, required this.pinnedHeader});

  @override
  Widget build(BuildContext context) {
    if (pinnedHeader) {
      return ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: child));
    }
    return child;
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
        onPressed: () => context.read<SeasonCubit>().goToSeason(item),
        borderRadius: 4,
        maxHeight: 50,
        minWidth: 40,
        maxWidth: 150,
      ),
    );
  }
}
