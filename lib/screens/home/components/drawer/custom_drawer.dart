import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import '../../cubit/home_cubit.dart';
import 'drawer_large_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<HomeCubit, List<Item>>((cubit) => cubit.state.items);
    return Drawer(
        child: ListView(controller: ScrollController(), children: [
      const DrawerLargeButton(
        index: 0,
        name: 'Home',
        icon: Icons.home_outlined,
      ),
      ...items.map((i) => DrawerLargeButton(
            index: items.indexOf(i) + 1,
            name: i.name ?? '',
            icon: _getRightIconForCollectionType(i.collectionType),
          ))
    ]));
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
