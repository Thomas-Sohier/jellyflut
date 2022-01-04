import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

part 'list_items_grid_skeleton.dart';
part 'list_items_grid_vertical_list.dart';
part 'list_items_grid_horizontal_list.dart';
part 'skeleton_poster_item.dart';

class ListItemsSkeleton extends StatelessWidget {
  final listType;
  ListItemsSkeleton({required this.listType});

  @override
  Widget build(BuildContext context) {
    switch (listType) {
      case ListType.LIST:
        return ListItemsVerticalSkeleton();
      case ListType.POSTER:
        return ListItemsHorizontalSkeleton();
      case ListType.GRID:
        return ListItemsGridSkeleton();
      default:
        return ListItemsGridSkeleton();
    }
  }
}
