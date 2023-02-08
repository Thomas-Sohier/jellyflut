import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/home/home_category/cubit/home_category_cubit.dart';
import 'package:jellyflut/screens/home/home_category/home_category_title.dart';
import 'package:jellyflut/theme/theme.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategory extends StatelessWidget {
  // ignore: unused_element
  const HomeCategory._(this.item, this.itemType);

  const HomeCategory.fromItem({required this.item}) : itemType = null;

  const HomeCategory.fromType({required this.itemType}) : item = null;

  final Item? item;
  final HomeCategoryType? itemType;
  final double height = 220;
  final double gapSize = 20;

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
  const HomeCategoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCategoryCubit, HomeCategoryState>(builder: (_, state) {
      switch (state.status) {
        case HomeCategoryStatus.success:
          if (state.items.isEmpty) return const SizedBox();
          return const HomeCategoryLoaded();
        case HomeCategoryStatus.initial:
        case HomeCategoryStatus.loading:
        default:
          return const HomeCategoryShimmer();
      }
    });
  }
}

class HomeCategoryLoaded extends StatelessWidget {
  const HomeCategoryLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCategoryCubit>();
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeCategoryTitle(cubit.state.categoryName,
              onTap: () => cubit.state.parentItem != null
                  ? context.router.root.push(r.CollectionPage(item: cubit.state.parentItem!))
                  : {}),
          SizedBox(
              height: itemPosterHeight + itemPosterLabelHeight,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.state.items.length,
                  itemExtent: (itemPosterHeight * cubit.state.items.first.getPrimaryAspectRatio(showParent: true)) + 20,
                  itemBuilder: (context, index) => ItemPoster(
                        cubit.state.items[index],
                        width: double.infinity,
                        height: double.infinity,
                        boxFit: BoxFit.cover,
                      )))
        ]);
  }
}

class HomeCategoryShimmer extends StatelessWidget {
  const HomeCategoryShimmer({super.key});
  final double height = 220;
  final double gapSize = 20;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    height: 30,
                    width: 70,
                    color: Colors.white30,
                  )),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.white30,
                      ))),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                          height: itemPosterHeight,
                          child: ListView.builder(
                              itemCount: 3,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: height,
                                        width: height * (2 / 3),
                                        color: Colors.white30,
                                      )))))),
                ],
              ))
        ]));
  }
}
