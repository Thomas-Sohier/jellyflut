import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:universal_io/io.dart';
import '../../home_cubit/home_cubit.dart';
import '../../home_drawer_cubit/home_drawer_cubit.dart';
import 'drawer_large_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final homeDrawerCubit = context.read<HomeDrawerCubit>();
    return FocusableActionDetector(
        enabled: false,
        onFocusChange: (value) {
          if (isAndroidTv) {
            homeDrawerCubit.changeViewMode(value ? LayoutType.desktop : LayoutType.tablet);
          }
        },
        child: BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
          buildWhen: (previous, current) =>
              previous.drawerLayout != current.drawerLayout ||
              previous.drawerType != current.drawerType ||
              previous.fixDrawerType != current.fixDrawerType,
          builder: (_, state) => AnimatedContainer(
              width: state.getDrawerWidth,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: guessDrawerColor(state.drawerLayout, context)),
              duration: Duration(milliseconds: 200),
              child: Column(
                children: [
                  const Expanded(child: _DrawerButtons()),
                  const SizedBox(height: 4),
                  const _BottomActions(),
                  const SizedBox(height: 4),
                ],
              )),
        ));
  }

  Color guessDrawerColor(DrawerLayout layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case DrawerLayout.mobile:
        return currentTheme.colorScheme.background;
      case DrawerLayout.tablet:
      case DrawerLayout.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) {
          return currentTheme.colorScheme.secondaryContainer;
        }
        return currentTheme.colorScheme.primaryContainer;
    }
  }
}

class _DrawerButtons extends StatelessWidget {
  const _DrawerButtons();

  @override
  Widget build(BuildContext context) {
    final items = context.select<HomeCubit, List<Item>>((cubit) => cubit.state.items);
    return BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
        buildWhen: (previous, current) => previous.drawerLayout != current.drawerLayout,
        builder: (_, state) => ListView(controller: ScrollController(), children: [
              DrawerLargeButton(
                index: 0,
                name: 'Home',
                activeColor: guessActiveColor(state.drawerLayout, context),
                inactiveColor: guessInactiveColor(state.drawerLayout, context),
                icon: Icons.home_outlined,
              ),
              ...items.map((i) => DrawerLargeButton(
                    index: items.indexOf(i) + 1,
                    name: i.name ?? '',
                    activeColor: guessActiveColor(state.drawerLayout, context),
                    inactiveColor: guessInactiveColor(state.drawerLayout, context),
                    icon: _getRightIconForCollectionType(i.collectionType),
                  ))
            ]));
  }

  Color guessActiveColor(DrawerLayout layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case DrawerLayout.mobile:
        return currentTheme.colorScheme.primary;
      case DrawerLayout.tablet:
      case DrawerLayout.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) {
          return currentTheme.colorScheme.secondary;
        }
        return currentTheme.colorScheme.primary;
    }
  }

  Color guessInactiveColor(DrawerLayout layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case DrawerLayout.mobile:
        return currentTheme.colorScheme.onBackground;
      case DrawerLayout.tablet:
      case DrawerLayout.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) {
          return currentTheme.colorScheme.onSecondaryContainer;
        }
        return currentTheme.colorScheme.onPrimaryContainer;
    }
  }

  IconData _getRightIconForCollectionType(CollectionType? collectionType) {
    switch (collectionType) {
      case CollectionType.books:
        return Icons.book_outlined;
      case CollectionType.tvshows:
        return Icons.tv_outlined;
      case CollectionType.boxsets:
        return Icons.account_box_outlined;
      case CollectionType.movies:
        return Icons.movie_outlined;
      case CollectionType.music:
        return Icons.music_note_outlined;
      case CollectionType.homevideos:
        return Icons.video_camera_back_outlined;
      case CollectionType.musicvideos:
        return Icons.music_video_outlined;
      case CollectionType.mixed:
        return Icons.blender_outlined;
      default:
        return Icons.tv;
    }
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeDrawerCubit>();
    return BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
        buildWhen: (previous, current) =>
            previous.fixDrawerType != current.fixDrawerType || previous.drawerType != current.drawerType,
        builder: (_, state) {
          if (Platform.isAndroid || Platform.isIOS || state.drawerLayout.isMobile) return const SizedBox();
          return Column(
            children: [
              const _DrawerDivider(),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                OutlinedButtonSelector(
                    onPressed: cubit.toggleFixDrawerSize,
                    shape: CircleBorder(),
                    child: IgnorePointer(
                        child: ExcludeFocus(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(state.fixDrawerType ? Icons.lock : Icons.lock_open,
                            color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ))),
                if (state.fixDrawerType)
                  OutlinedButtonSelector(
                      onPressed: cubit.toggleDrawerSize,
                      shape: CircleBorder(),
                      child: IgnorePointer(
                        child: ExcludeFocus(
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                    state.isCompact
                                        ? Icons.keyboard_double_arrow_right
                                        : Icons.keyboard_double_arrow_left,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer))),
                      ))
              ]),
            ],
          );
        });
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      height: 2,
      endIndent: 4,
      indent: 4,
    );
  }
}
