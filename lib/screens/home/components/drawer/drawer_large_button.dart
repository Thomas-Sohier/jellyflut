import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';

import 'package:jellyflut/routes/router.gr.dart';

class DrawerLargeButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String name;

  const DrawerLargeButton(
      {super.key, required this.index, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).colorScheme.onBackground;
    final isActive = context.tabsRouter.activeIndex == index;
    return InkWell(
        onTap: () {
          context.tabsRouter
            ..setActiveIndex(index)
            ..innerRouterOf<StackRouter>(HomeRouter.name)?.push(HomeRoute());
          customRouter.pop();
        },
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
