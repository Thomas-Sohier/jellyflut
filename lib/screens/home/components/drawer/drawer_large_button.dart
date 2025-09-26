import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import '../../home_drawer_cubit/home_drawer_cubit.dart';

class DrawerLargeButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String name;
  final Color? activeColor;
  final Color? inactiveColor;

  const DrawerLargeButton({
    super.key,
    required this.index,
    required this.icon,
    required this.name,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final homeDrawerCubit = context.read<HomeDrawerCubit>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: OutlinedButtonSelector(
        onPressed: () {
          context.tabsRouter.setActiveIndex(index);
          homeDrawerCubit.changeCurrentDrawerSelection(index, name);
        },
        child: _ButtonUI(index: index, icon: icon, name: name, activeColor: activeColor, inactiveColor: inactiveColor),
      ),
    );
  }
}

/// Widget privé qui gère l'aspect visuel du bouton en fonction de son état (actif/inactif).
class _ButtonUI extends StatelessWidget {
  final int index;
  final IconData icon;
  final String name;
  final Color? activeColor;
  final Color? inactiveColor;

  const _ButtonUI({required this.index, required this.icon, required this.name, this.activeColor, this.inactiveColor});

  @override
  Widget build(BuildContext context) {
    final finalActiveColor = activeColor ?? Theme.of(context).colorScheme.secondary;
    final finalInactiveColor = inactiveColor ?? Theme.of(context).colorScheme.onSecondaryContainer;

    return BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
      buildWhen: (previous, current) => previous.currentIndexSelected != current.currentIndexSelected,
      builder: (_, state) {
        final isActive = index == state.currentIndexSelected;
        final currentIconColor = isActive ? finalActiveColor : finalInactiveColor;
        final currentTextColor = isActive ? finalActiveColor : finalInactiveColor;

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? finalActiveColor.withAlpha(50) : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: currentIconColor, size: 28),
              _ButtonLabel(name: name, textColor: currentTextColor),
            ],
          ),
        );
      },
    );
  }
}

/// Widget privé qui gère l'affichage du texte du bouton.
/// Il se reconstruit uniquement si le layout du drawer change (par exemple, passage en mode compact).
class _ButtonLabel extends StatelessWidget {
  final String name;
  final Color textColor;

  const _ButtonLabel({required this.name, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
      buildWhen: (previous, current) => previous.isCompact != current.isCompact,
      builder: (_, state) {
        if (state.isCompact) {
          return const SizedBox.shrink();
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor),
            ),
          ),
        );
      },
    );
  }
}
