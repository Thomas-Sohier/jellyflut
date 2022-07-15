import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/home/home_tabs_provider.dart';

/// This mixin allow to handle focus while tabs is inactive
/// It prevent the cursor from focusing off-screen tab while using d-pad
mixin HomeTab<T extends StatefulWidget> on State<T> {
  late final HomeTabsProvider _homeTabsProvider;
  late final TabsRouter _tabsRouter;
  final List<Widget> tabs = [];
  late TabController tabController;
  late ValueNotifier<bool> excluding;

  @override
  void initState() {
    super.initState();
    excluding = ValueNotifier(false);
    _tabsRouter = context.tabsRouter;
    _tabsRouter.addListener(_excludeWatcher);
    _homeTabsProvider = HomeTabsProvider();
    _homeTabsProvider.setTabs(tabs, tabController);
  }

  Widget parentBuild({Widget? child}) {
    return ValueListenableBuilder<bool>(
      valueListenable: excluding,
      builder: (BuildContext context, bool value, Widget? child) {
        return ExcludeFocus(excluding: value, child: child ?? const SizedBox());
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
    final activeChild = _tabsRouter.stack[index].arguments as dynamic;
    if (activeChild?.key == widget.key) {
      excluding.value = false;
      _homeTabsProvider.setTabs(tabs, tabController);
    } else {
      excluding.value = true;
    }
  }
}
