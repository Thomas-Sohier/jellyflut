import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart' as globals;

import 'cubit/collection_cubit.dart';

class Tab extends StatelessWidget {
  const Tab({super.key});

  @override
  Widget build(BuildContext context) {
    final episodes = context.read<CollectionCubit>().state.episodes;
    return ListItems.fromList(
        items: episodes,
        listType: ListType.list,
        verticalListPosterHeight: globals.itemPosterHeight,
        physics: NeverScrollableScrollPhysics(),
        showIfEmpty: false,
        showTitle: false,
        showSorting: false);
  }
}
