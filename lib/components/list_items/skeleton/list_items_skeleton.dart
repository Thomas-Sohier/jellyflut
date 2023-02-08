import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/collection_bloc.dart';

part 'list_items_grid_skeleton.dart';
part 'list_items_horizontal_list.dart';
part 'list_items_vertical_list_skeleton.dart';
part 'skeleton_poster_item.dart';

class ListItemsSkeleton extends StatelessWidget {
  final double verticalListPosterHeight;
  final double horizontalListPosterHeight;
  final double gridPosterHeight;

  const ListItemsSkeleton(
      {this.verticalListPosterHeight = 200, this.horizontalListPosterHeight = 200, this.gridPosterHeight = 200});

  @override
  Widget build(BuildContext context) {
    switch (context.read<CollectionBloc>().state.listType) {
      case ListType.list:
        return const ListItemsVerticalSkeleton();
      case ListType.poster:
        return const ListItemsHorizontalSkeleton();
      case ListType.grid:
        return const ListItemsGridSkeleton();
      default:
        return const ListItemsGridSkeleton();
    }
  }
}
