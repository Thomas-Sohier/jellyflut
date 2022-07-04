import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/cubit/collection_cubit.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab.dart';

class TabsItems extends StatelessWidget {
  const TabsItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Tab(
      key: ValueKey(context.read<CollectionCubit>().state.season),
      items: context.read<CollectionCubit>().state.episodes,
      itemPosterHeight: 150,
    );
  }
}
