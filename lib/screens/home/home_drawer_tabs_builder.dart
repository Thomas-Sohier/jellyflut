import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/home/home_cubit/home_cubit.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';

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
        appBarBuilder: (_, __) =>
            AppBar(flexibleSpace: HeaderBar(), bottom: BottomTabBar(homeTabsCubit: context.read<HomeTabsCubit>())),
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
  final HomeTabsCubit homeTabsCubit;
  const BottomTabBar({super.key, required this.homeTabsCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabsCubit, HomeTabsState>(
        bloc: homeTabsCubit,
        buildWhen: (previous, current) =>
            previous.currentHomeTabController != current.currentHomeTabController || previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case Status.initial:
            case Status.loading:
              return const SizedBox();
            case Status.success:
              if (state.currentHomeTabControllerTabs.isEmpty) {
                return const SizedBox();
              }
              return TabBar(
                  controller: state.currentHomeTabController?.tabController,
                  tabs: state.currentHomeTabController?.tabs ?? []);
            default:
              return const SizedBox();
          }
        });
  }

  @override
  Size get preferredSize =>
      homeTabsCubit.state.currentHomeTabControllerTabs.isNotEmpty ? Size.fromHeight(50) : Size.fromHeight(0);
}
