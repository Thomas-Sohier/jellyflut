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
    return InkWell(
        onTap: () => tabsContext.tabsRouter
          ..setActiveIndex(index)
          ..innerRouterOf<StackRouter>(HomeRouter.name)!.push(HomeRoute()),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 28,
              )
            ],
          ),
        ));
  }
}
