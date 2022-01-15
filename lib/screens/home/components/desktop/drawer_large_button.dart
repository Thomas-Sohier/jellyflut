import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
    final activeColor = Theme.of(context).colorScheme.secondary;
    final inactiveColor = Theme.of(context).primaryColor;
    final isActive = tabsContext.tabsRouter.activeIndex == index;
    return InkWell(
        onTap: () => tabsContext.tabsRouter
          ..setActiveIndex(index)
          ..innerRouterOf<StackRouter>(HomeRouter.name)?.push(HomeRoute()),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: isActive ? activeColor.withAlpha(50) : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
              child: Row(
                children: [
                  Icon(icon,
                      color: isActive ? activeColor : inactiveColor, size: 28),
                  SizedBox(width: 12),
                  Flexible(
                      child: Text(name,
                          style: TextStyle(
                              color: isActive ? activeColor : inactiveColor)))
                ],
              )),
        ));
  }
}
