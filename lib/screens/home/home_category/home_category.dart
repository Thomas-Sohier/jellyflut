import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart'; // Supposé pour les constantes de shimmer
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/screens/home/home_category/cubit/home_category_cubit.dart';
import 'package:jellyflut/screens/home/home_category/home_category_title.dart';
import 'package:jellyflut/theme/theme.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';

// CENTRALISATION DES CONSTANTES
const double _kPosterHeight = 220.0;
const double _kPosterLabelHeight = 40.0;
const double _kHorizontalPadding = 12.0;
const double _kItemSpacing = 8.0;
const double _kDefaultAspectRatio = 2 / 3;

class HomeCategory extends StatelessWidget {
  const HomeCategory.fromItem({super.key, required this.item}) : itemType = null;
  const HomeCategory.fromType({super.key, required this.itemType}) : item = null;

  final Item? item;
  final HomeCategoryType? itemType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCategoryCubit>(
      create: (_) =>
          HomeCategoryCubit(itemsRepository: context.read<ItemsRepository>(), parentItem: item, type: itemType),
      child: const HomeCategoryView(),
    );
  }
}

class HomeCategoryView extends StatelessWidget {
  const HomeCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<HomeCategoryCubit>().state.status;
    final items = context.watch<HomeCategoryCubit>().state.items;

    switch (status) {
      case HomeCategoryStatus.success:
        if (items.isEmpty) return const SizedBox.shrink();
        return const HomeCategoryLoaded();
      case HomeCategoryStatus.initial:
      case HomeCategoryStatus.loading:
      default:
        return const HomeCategoryShimmer();
    }
  }
}

class HomeCategoryLoaded extends StatelessWidget {
  const HomeCategoryLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<HomeCategoryCubit>().state;
    final firstItemAspectRatio = state.items.first.getPrimaryAspectRatio(showParent: true);
    final posterWidth = _kPosterHeight * firstItemAspectRatio;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCategoryTitle(
          state.categoryName,
          onTap: () {
            if (state.parentItem != null) {
              context.router.root.push(CollectionRoute(item: state.parentItem!));
            }
          },
        ),
        SizedBox(
          height: _kPosterHeight + _kPosterLabelHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
            itemCount: state.items.length,
            itemExtent: posterWidth + _kItemSpacing,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: _kItemSpacing),
                child: ItemPoster(state.items[index], height: _kPosterHeight),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Affiche un placeholder de chargement (shimmer).
class HomeCategoryShimmer extends StatelessWidget {
  const HomeCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const shimmerPosterWidth = _kPosterHeight * _kDefaultAspectRatio;
    return Shimmer.fromColors(
      enabled: shimmerAnimation,
      baseColor: shimmerColor1,
      highlightColor: shimmerColor2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding, vertical: 15),
            child: Container(height: 30, width: 120, color: Colors.white),
          ),
          SizedBox(
            height: _kPosterHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4, // Affiche 4 placeholders
              itemExtent: shimmerPosterWidth + _kItemSpacing,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: _kItemSpacing),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(height: _kPosterHeight, width: shimmerPosterWidth, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
