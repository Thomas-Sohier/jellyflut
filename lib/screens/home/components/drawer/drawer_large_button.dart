import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import 'package:jellyflut/routes/router.gr.dart' as r;

import '../../home_drawer_cubit/home_drawer_cubit.dart';

class DrawerLargeButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String name;
  final Color? activeColor;
  final Color? inactiveColor;

  const DrawerLargeButton(
      {super.key, required this.index, required this.icon, required this.name, this.activeColor, this.inactiveColor});

  @override
  Widget build(BuildContext context) {
    final homeDrawerCubit = context.read<HomeDrawerCubit>();
    final finalActiveColor = activeColor ?? Theme.of(context).colorScheme.secondary;
    final finalInactiveColor = inactiveColor ?? Theme.of(context).colorScheme.onSecondaryContainer;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OutlinedButtonSelector(
          onPressed: () {
            context.tabsRouter
              ..setActiveIndex(index)
              ..innerRouterOf<StackRouter>(r.HomeRouter.name)?.push(r.HomeRouter());
            homeDrawerCubit.changeCurrentDrawerSelection(index, name);
            context.router.root.pop();
          },
          child: BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
              buildWhen: (previous, current) => previous.currentIndexSelected != current.currentIndexSelected,
              builder: (_, state) {
                final isActive = index == state.currentIndexSelected;
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isActive ? finalActiveColor.withAlpha(50) : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      shape: BoxShape.rectangle),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: buttonBody(context, finalActiveColor, finalInactiveColor, isActive)),
                );
              })),
    );
  }

  Widget buttonBody(BuildContext context, Color activeColor, Color inactiveColor, bool isActive) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
        BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
            buildWhen: (previous, current) =>
                previous.drawerType != current.drawerType ||
                previous.drawerLayout != current.drawerLayout ||
                previous.fixDrawerType != current.fixDrawerType,
            builder: (_, state) {
              if (state.isCompact) return const SizedBox();
              return Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: isActive ? activeColor : inactiveColor)),
              ));
            })
      ],
    );
  }
}
