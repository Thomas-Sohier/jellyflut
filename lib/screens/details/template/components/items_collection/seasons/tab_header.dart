import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/template/components/details/details_ui_model.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';

import 'cubit/season_cubit.dart';

const _height = 80.0;

class TabHeader extends SliverPersistentHeaderDelegate {
  final EdgeInsets padding;
  final bool isMobile;

  const TabHeader({this.isMobile = false, this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<DetailsUIModel>().updatePinnedStateFromShrink(shrinkOffset);
    });

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
            return const SizedBox(height: _height);
        }
      },
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is TabHeader) {
      return isMobile || oldDelegate.padding != padding;
    }
    return true;
  }
}

class ShimmerHeaderBar extends StatelessWidget {
  final EdgeInsets padding;
  const ShimmerHeaderBar({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.select((DetailsUIModel model) => model.layout.isMobile);
    final isPinned = context.select((DetailsUIModel model) => model.isPinned);
    return _HeaderBlur(
      pinnedHeader: isPinned,
      child: SizedBox(
        height: _height,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          highlightColor: Theme.of(context).colorScheme.onSurface.withAlpha(100),
          child: AnimatedPadding(
            padding: isPinned && isMobile ? padding.copyWith(left: padding.left + 40) : padding,
            duration: const Duration(milliseconds: 200),
            child: const _ShimmerList(),
          ),
        ),
      ),
    );
  }
}

// Widget privé pour le contenu statique du shimmer.
class _ShimmerList extends StatelessWidget {
  static const EdgeInsets buttonPadding = EdgeInsets.only(right: 12);
  static const double height = 50;
  static const double width = 150;
  static const int count = 4;

  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: ColoredBox(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeaderBar extends StatelessWidget {
  final EdgeInsets padding;

  const HeaderBar({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.select((DetailsUIModel model) => model.layout.isMobile);
    final isPinned = context.select((DetailsUIModel model) => model.isPinned);

    return _HeaderBlur(
      pinnedHeader: isPinned,
      child: SizedBox(
        height: _height,
        child: AnimatedPadding(
          padding: isPinned && isMobile ? padding.copyWith(left: padding.left + 40) : padding,
          duration: const Duration(milliseconds: 200),
          child: const _HeaderSeasonsButtons(),
        ),
      ),
    );
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
        },
      ),
    );
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
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: child),
      );
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
