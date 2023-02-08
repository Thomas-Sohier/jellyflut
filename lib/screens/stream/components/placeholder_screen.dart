import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import '../cubit/stream_cubit.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Positioned.fill(child: Align(alignment: Alignment.center, child: _Background())),
        Positioned(top: 10, left: 10, child: SelectableBackButton())
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    final item = context.read<StreamCubit>().state.parentItem;
    if (item == null) return const CircularProgressIndicator();
    if (item.type != ItemType.TvChannel) {
      return AsyncImage(
          item: item,
          width: double.infinity,
          height: double.infinity,
          boxFit: BoxFit.cover,
          imageType: ImageType.Backdrop,
          showParent: true,
          backup: item.type == ItemType.TvChannel ? true : false);
    }
    return AsyncImage(item: item, width: 300, height: 300, boxFit: BoxFit.contain, imageType: ImageType.Primary);
  }
}
