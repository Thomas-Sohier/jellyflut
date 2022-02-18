import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

part 'list_items_grid_skeleton.dart';
part 'list_items_horizontal_list.dart';
part 'list_items_vertical_list_skeleton.dart';
part 'skeleton_poster_item.dart';

class ListItemsSkeleton extends StatelessWidget {
  final listType;
  final double verticalListPosterHeight;
  final double horizontalListPosterHeight;
  final double gridPosterHeight;
  ListItemsSkeleton(
      {required this.listType,
      required this.verticalListPosterHeight,
      required this.horizontalListPosterHeight,
      required this.gridPosterHeight});

  @override
  Widget build(BuildContext context) {
    switch (listType) {
      case ListType.LIST:
        return ListItemsVerticalSkeleton(
            verticalListPosterHeight: verticalListPosterHeight);
      case ListType.POSTER:
        return ListItemsHorizontalSkeleton(
            horizontalListPosterHeight: horizontalListPosterHeight);
      case ListType.GRID:
        return ListItemsGridSkeleton(gridPosterHeight: gridPosterHeight);
      default:
        return ListItemsGridSkeleton(gridPosterHeight: gridPosterHeight);
    }
  }
}
