import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// This mixin allow to handle focus while tabs is inactive
/// It prevent the cursor from focusing off-screen tab while using d-pad
mixin HomeTab<T extends StatefulWidget> on State<T> {
  late final TabsRouter _tabsRouter;
  late bool excluding;

  @override
  void initState() {
    super.initState();
    excluding = false;
    _tabsRouter = context.tabsRouter;
    _tabsRouter.addListener(_excludeWatcher);
  }

  @override
  void dispose() {
    super.dispose();
    _tabsRouter.removeListener(_excludeWatcher);
  }

  void _excludeWatcher() {
    final index = _tabsRouter.activeIndex;
    final activeChild = _tabsRouter.stack[index].child;
    if (activeChild.key == widget.key) {
      setState(() => excluding = false);
    } else {
      setState(() => excluding = true);
    }
  }
}
