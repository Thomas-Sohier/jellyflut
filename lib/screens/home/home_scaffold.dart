// lib/screens/home/home_scaffold.dart

import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut/screens/home/components/drawer/custom_drawer.dart';
import 'package:jellyflut/screens/home/header_bar.dart';
import 'package:jellyflut/screens/home/home_drawer_cubit/home_drawer_cubit.dart';

class HomeScaffold extends StatelessWidget {
  final List<PageRouteInfo<dynamic>> routes;

  const HomeScaffold({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderScreen(
      builder: (_, constraint, type) {
        context.read<HomeDrawerCubit>().changeViewMode(type);
        return AutoTabsScaffold(
          drawer: type.isMobile ? const CustomDrawer() : null,
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 300,
          routes: routes,
          transitionBuilder: (context, child, animation) {
            return Row(
              children: [
                if (!type.isMobile) const CustomDrawer(),
                Expanded(
                  child: Column(
                    children: [
                      AppBar(flexibleSpace: const HeaderBar()),
                      Expanded(
                        child: PageTransitionSwitcher(
                          transitionBuilder: (Widget child, Animation<double> _, Animation<double> secondaryAnimation) {
                            return FadeThroughTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              fillColor: Theme.of(context).colorScheme.surface,
                              child: child,
                            );
                          },
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
