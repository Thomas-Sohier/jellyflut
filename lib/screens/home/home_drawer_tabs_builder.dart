import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut/screens/home/components/drawer/custom_drawer.dart';
import 'package:jellyflut/screens/home/home_cubit/home_cubit.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';

import 'header_bar.dart';
import 'home_drawer_cubit/home_drawer_cubit.dart';

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
    return BlocProvider<HomeDrawerCubit>(create: (_) => HomeDrawerCubit(), child: const HomeTabsView());
  }
}

class HomeTabsView extends StatelessWidget {
  const HomeTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final homeDrawerCubit = context.read<HomeDrawerCubit>();
    return LayoutBuilderScreen(builder: (_, contraint, type) {
      homeDrawerCubit.changeViewMode(type);
      return AutoTabsScaffold(
          drawer: type.isMobile ? const CustomDrawer() : null,
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 300,
          routes: homeCubit.state.routes,
          builder: (context, child, animation) {
            return Row(children: [
              if (!type.isMobile) const CustomDrawer(),
              Expanded(
                  child: Column(
                children: [
                  AppBar(flexibleSpace: const HeaderBar()),
                  Expanded(
                    child: PageTransitionSwitcher(
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
                        child: child),
                  ),
                ],
              ))
            ]);
          });
    });
  }
}

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabsCubit, HomeTabsState>(
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
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TabBar(
                    controller: state.currentHomeTabController?.tabController,
                    tabs: state.currentHomeTabController?.tabs ?? []),
              );
            default:
              return const SizedBox();
          }
        });
  }
}
