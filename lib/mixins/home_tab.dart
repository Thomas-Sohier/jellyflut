import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';

/// This mixin allow to handle focus while tabs is inactive
/// It prevent the cursor from focusing off-screen tab while using d-pad
///
/// Must be included in the root tab widget
mixin HomeTab<T extends StatefulWidget> on State<T> {
  @protected
  List<Widget> get tabs;

  @protected
  TabController get tabController;

  @protected
  Key get tabControllerUniqueKey;

  late final TabsRouter _tabsRouter;
  late final HomeTabsCubit _homeTabsCubit;
  late final ValueNotifier<bool> excluding;

  @override
  void initState() {
    super.initState();
    // TODO listen to tabs router and check tab key to know if current widget is on top
    excluding = ValueNotifier(false);
    _tabsRouter = context.tabsRouter;
    _tabsRouter.addListener(_excludeWatcher);
    _homeTabsCubit = context.read<HomeTabsCubit>();
    _homeTabsCubit.addHomeTabController(
        tabControllerUniqueKey, HomeTabController(tabs: tabs, tabController: tabController));
    _homeTabsCubit.setCurrentHomeTabController(tabControllerUniqueKey);
  }

  Widget visibiltyBuilder({Widget? child}) {
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
    tabController.dispose();
  }

  void _excludeWatcher() {
    final index = _tabsRouter.activeIndex;
    final activeChildArgs = _tabsRouter.stack[index].arguments as dynamic;
    if (activeChildArgs?.key == widget.key) {
      excluding.value = false;
      _homeTabsCubit.setCurrentHomeTabController(tabControllerUniqueKey);
    } else {
      excluding.value = true;
    }
  }
}
