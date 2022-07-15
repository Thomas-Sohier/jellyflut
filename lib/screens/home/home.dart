import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/home/home_category/home_category.dart';

import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'cubit/home_cubit.dart';
import 'home_category/cubit/home_category_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(itemsRepository: context.read<ItemsRepository>()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeTab, TickerProviderStateMixin {
  @override
  set tabController(TabController tabController) {
    super.tabController = tabController;
  }

  @override
  void initState() {
    tabController = TabController(length: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.select<HomeCubit, List<Item>>((cubit) => cubit.state.items);

    return super.parentBuild(
        child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      const SliverToBoxAdapter(child: HomeCategory.fromType(itemType: HomeCategoryType.resume)),
      const SliverToBoxAdapter(child: HomeCategory.fromType(itemType: HomeCategoryType.latest)),
      ...items.map((i) => SliverToBoxAdapter(child: HomeCategory.fromItem(item: i))).toList()
    ]));
  }
}
