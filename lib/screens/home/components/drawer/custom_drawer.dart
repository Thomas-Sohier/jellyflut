import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import '../../home_cubit/home_cubit.dart';
import '../../home_drawer_cubit/home_drawer_cubit.dart';
import 'drawer_large_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<HomeCubit, List<Item>>((cubit) => cubit.state.items);
    return FocusableActionDetector(
        enabled: false,
        onFocusChange: (value) =>
            context.read<HomeDrawerCubit>().changeViewMode(value ? LayoutType.desktop : LayoutType.tablet),
        child: BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
            buildWhen: (previous, current) => previous.screenLayout != current.screenLayout,
            builder: (_, state) => AnimatedContainer(
                width: guessDrawerWidth(state.screenLayout),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: guessDrawerColor(state.screenLayout, context)),
                duration: Duration(milliseconds: 300),
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: items.length + 1,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return DrawerLargeButton(
                          index: 0,
                          name: 'Home',
                          activeColor: guessActiveColor(state.screenLayout, context),
                          inactiveColor: guessInactiveColor(state.screenLayout, context),
                          icon: Icons.home_outlined,
                        );
                      }
                      final item = items.elementAt(index - 1);
                      return DrawerLargeButton(
                        index: index,
                        name: item.name ?? '',
                        activeColor: guessActiveColor(state.screenLayout, context),
                        inactiveColor: guessInactiveColor(state.screenLayout, context),
                        icon: _getRightIconForCollectionType(item.collectionType),
                      );
                    }))));
  }

  double guessDrawerWidth(LayoutType layoutType) {
    switch (layoutType) {
      case LayoutType.tablet:
        return 75;
      case LayoutType.desktop:
      case LayoutType.mobile:
      default:
        return 300;
    }
  }

  Color guessDrawerColor(LayoutType layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case LayoutType.mobile:
        return currentTheme.colorScheme.background;
      case LayoutType.tablet:
      case LayoutType.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) return currentTheme.colorScheme.secondaryContainer;
        return currentTheme.colorScheme.primaryContainer;
    }
  }

  Color guessActiveColor(LayoutType layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case LayoutType.mobile:
        return currentTheme.colorScheme.primary;
      case LayoutType.tablet:
      case LayoutType.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) return currentTheme.colorScheme.secondary;
        return currentTheme.colorScheme.primary;
    }
  }

  Color guessInactiveColor(LayoutType layoutType, BuildContext context) {
    final currentTheme = Theme.of(context);
    switch (layoutType) {
      case LayoutType.mobile:
        return currentTheme.colorScheme.onBackground;
      case LayoutType.tablet:
      case LayoutType.desktop:
      default:
        if (currentTheme.brightness == Brightness.dark) return currentTheme.colorScheme.onSecondaryContainer;
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
