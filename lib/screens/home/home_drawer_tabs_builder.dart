import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/providers/home/home_tabs_provider.dart';
import 'package:jellyflut/screens/home/cubit/home_cubit.dart';
import 'package:provider/provider.dart';

import 'components/drawer/custom_drawer.dart';
import 'header_bar.dart';

class HomeDrawerTabsBuilder extends StatelessWidget {
  const HomeDrawerTabsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
      switch (state.status) {
        case HomeStatus.success:
          return const HomeTabs();
        case HomeStatus.initial:
        case HomeStatus.loading:
        default:
          return const SizedBox();
      }
    });
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return AutoTabsScaffold(
        drawer: const CustomDrawer(),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 300,
        routes: cubit.state.routes,
        appBarBuilder: (_, __) => AppBar(
            flexibleSpace: HeaderBar(), bottom: BottomTabBar(homeTabsProvider: context.read<HomeTabsProvider>())),
        builder: (context, child, animation) {
          return PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> _,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: Theme.of(context).colorScheme.background,
                child: child,
              );
            },
            child: child,
          );
        });
  }
}

class BottomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeTabsProvider homeTabsProvider;
  const BottomTabBar({super.key, required this.homeTabsProvider});

  @override
  Widget build(BuildContext context) {
    if (context.read<HomeTabsProvider>().getTabs.isNotEmpty) {
      return Consumer<HomeTabsProvider>(
          builder: (_, provider, ___) => TabBar(controller: provider.getTabController, tabs: provider.getTabs));
    }
    return const SizedBox();
  }

  @override
  Size get preferredSize => homeTabsProvider.getTabs.isNotEmpty ? Size.fromHeight(50) : Size.fromHeight(0);
}
