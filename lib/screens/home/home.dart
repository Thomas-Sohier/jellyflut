import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/screens/home/home_category/home_category.dart';

import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'home_cubit/home_cubit.dart';
import 'home_category/cubit/home_category_cubit.dart';

class HomePage extends StatefulWidget {
  // This property is there to generate key property with build_runner and allow to use it in [HomeTab] mixin
  // ignore: unused_field
  final String? _blank;

  const HomePage({super.key, String? blank}) : _blank = blank;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, HomeTab {
  @override
  Key get tabControllerUniqueKey => ValueKey('HomeValueKey-unused');

  @override
  List<Widget> get tabs => const <Tab>[];

  @override
  TabController get tabController => TabController(length: tabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(itemsRepository: context.read<ItemsRepository>()),
      child: super.visibiltyBuilder(child: const HomeView()),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<HomeCubit, List<Item>>((cubit) => cubit.state.items);
    // TODO try to store HomeCategory "state" upper in widget tree using BLoC to allow [visibility] widget from [HomeTab] mixin
    // to not maintain state and allow better performance while resizing (for example)
    return CustomScrollView(controller: ScrollController(), scrollDirection: Axis.vertical, slivers: [
      const SliverToBoxAdapter(child: SizedBox(height: 10)),
      const SliverToBoxAdapter(child: HomeCategory.fromType(itemType: HomeCategoryType.resume)),
      const SliverToBoxAdapter(child: HomeCategory.fromType(itemType: HomeCategoryType.latest)),
      ...items.map((i) => SliverToBoxAdapter(child: HomeCategory.fromItem(item: i))).toList()
    ]);
  }
}
