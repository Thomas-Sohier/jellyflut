import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

typedef NavigationChangeBuilder = Widget Function(
    BuildContext context, RoutingController topMostRouter);

class NavigationListener extends StatefulWidget {
  final NavigationChangeBuilder builder;

  const NavigationListener({Key? key, required this.builder}) : super(key: key);

  @override
  _NavigationListenerState createState() => _NavigationListenerState();
}

class _NavigationListenerState extends State<NavigationListener> {
  bool _didInit = false;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      AutoRouterDelegate.of(context).controller.topMost,
    );
  }

  void _listener() {
    setState(() {});
  }

  @override
  void deactivate() {
    super.deactivate();
    AutoRouterDelegate.of(context).removeListener(_listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      AutoRouterDelegate.of(context).addListener(_listener);
    }
  }
}
