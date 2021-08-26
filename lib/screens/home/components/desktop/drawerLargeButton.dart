import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/routes/router.gr.dart';

class DrawerLargeButton extends StatelessWidget {
  final BuildContext tabsContext;
  final int index;
  final IconData icon;
  final String name;

  const DrawerLargeButton(
      {Key? key,
      required this.tabsContext,
      required this.index,
      required this.icon,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => tabsContext.tabsRouter
          ..setActiveIndex(index)
          ..innerRouterOf<StackRouter>(HomeRouter.name)!.push(HomeRoute()),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 4, 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              SizedBox(width: 12),
              Flexible(child: Text(name))
            ],
          ),
        ));
  }
}
