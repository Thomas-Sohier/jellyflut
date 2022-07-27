import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/routes/router.gr.dart' as r;

import '../../home_drawer_cubit/home_drawer_cubit.dart';

class DrawerLargeButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String name;

  const DrawerLargeButton({super.key, required this.index, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    final homeDrawerCubit = context.read<HomeDrawerCubit>();
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).colorScheme.onBackground;
    return InkWell(
        onTap: () {
          context.tabsRouter
            ..setActiveIndex(index)
            ..innerRouterOf<StackRouter>(r.HomeRouter.name)?.push(r.HomeRouter());
          homeDrawerCubit.changeCurrentDrawerSelection(index);
          context.router.root.pop();
        },
        child: BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
            buildWhen: (previous, current) => previous.currentIndexSelected != current.currentIndexSelected,
            builder: (_, state) {
              final isActive = index == state.currentIndexSelected;
              return Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isActive ? activeColor.withAlpha(50) : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: buttonBody(context, activeColor, inactiveColor, isActive)),
              );
            }));
  }

  Widget buttonBody(BuildContext context, Color activeColor, Color inactiveColor, bool isActive) {
    final homeDrawerCubit = context.read<HomeDrawerCubit>();
    if (homeDrawerCubit.state.screenLayout.isTablet)
      return Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28);
    return Row(
      children: [
        Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: isActive ? activeColor : inactiveColor)),
        ))
      ],
    );
  }
}
