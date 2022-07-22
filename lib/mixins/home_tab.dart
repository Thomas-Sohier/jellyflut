import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';

/// This mixin allow to handle focus while tabs is inactive
/// It prevent the cursor from focusing off-screen tab while using d-pad
mixin HomeTab<T extends StatefulWidget> on State<T> {
  //late final StackRouter _stackRouter;
  late final TabsRouter _tabsRouter;
  final List<Widget> tabs = [];
  late TabController tabController;
  late ValueNotifier<bool> excluding;

  @override
  void initState() {
    super.initState();
    excluding = ValueNotifier(false);
    // _stackRouter = context.router;
    // _stackRouter.addListener(_excludeWatcherOnPush);
    _tabsRouter = context.tabsRouter;
    _tabsRouter.addListener(_excludeWatcher);
    context.read<HomeTabsCubit>().setTabs(tabs, tabController);
  }

  Widget parentBuild({Widget? child}) {
    return ValueListenableBuilder<bool>(
      valueListenable: excluding,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
            visible: !value,
            maintainInteractivity: false,
            maintainAnimation: false,
            maintainSize: false,
            maintainState: true,
            child: ExcludeFocus(excluding: value, child: child ?? const SizedBox()));
      },
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabsRouter.removeListener(_excludeWatcher);
    //_stackRouter.removeListener(_excludeWatcherOnPush);
    tabController.dispose();
    //_stackRouter.dispose();
  }

  void _excludeWatcher() {
    final index = _tabsRouter.activeIndex;
    final activeChildArgs = _tabsRouter.stack[index].arguments as dynamic;
    if (activeChildArgs?.key == widget.key) {
      excluding.value = false;
      // _homeTabsProvider.setTabs(tabs, tabController);
    } else {
      excluding.value = true;
    }
  }

  // void _excludeWatcherOnPush() {
  //   try {
  //     // Try to find the key of current âge in stack
  //     // if none found we exclude it
  //     final activeChildKey = (_stackRouter.current.args as dynamic).key;
  //     if (activeChildKey == widget.key) {
  //       excluding.value = false;
  //       _homeTabsProvider.setTabs(tabs, tabController);
  //     } else {
  //       excluding.value = true;
  //     }
  //   } catch (_) {
  //     excluding.value = true;
  //   }
  // }
}
