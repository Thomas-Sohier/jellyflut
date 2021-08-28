import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/routes/router.gr.dart';

class DrawerTabletButton extends StatelessWidget {
  final BuildContext tabsContext;
  final int index;
  final IconData icon;

  const DrawerTabletButton(
      {Key? key,
      required this.tabsContext,
      required this.index,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).accentColor;
    final inactiveColor = Theme.of(context).primaryColor;
    final isActive = tabsContext.tabsRouter.activeIndex == index;
    return InkWell(
      onTap: () => tabsContext.tabsRouter
        ..setActiveIndex(index)
        ..innerRouterOf<StackRouter>(HomeRouter.name)?.push(HomeRoute()),
      child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: isActive ? activeColor.withAlpha(50) : Colors.transparent,
              shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 28,
                )
              ],
            ),
          )),
    );
  }
}
