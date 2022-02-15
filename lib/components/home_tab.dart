import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

class HomeTab extends StatefulWidget {
  final Widget child;
  HomeTab({Key? key, required this.child}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final TabsRouter _tabsRouter;
  late bool excluding;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
