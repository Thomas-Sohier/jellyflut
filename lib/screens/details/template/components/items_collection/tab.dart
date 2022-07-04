import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart' as globals;
import 'package:jellyflut_models/jellyflut_models.dart';

import 'cubit/collection_cubit.dart';

class Tab extends StatelessWidget {
  const Tab({super.key});

  @override
  Widget build(BuildContext context) {
    final episodes = context.read<CollectionCubit>().state.episodes;
    return ListItems.fromList(
        category: Category(items: episodes, totalRecordCount: episodes.length, startIndex: 0),
        listType: ListType.LIST,
        verticalListPosterHeight: globals.itemPosterHeight,
        physics: NeverScrollableScrollPhysics(),
        showIfEmpty: false,
        showTitle: false,
        showSorting: false);
  }
}
