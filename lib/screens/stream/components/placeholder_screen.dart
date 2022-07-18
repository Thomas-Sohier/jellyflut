import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import '../cubit/stream_cubit.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = context.read<StreamCubit>().state.streamItem.item;
    return AsyncImage(
        item: item,
        width: double.infinity,
        height: double.infinity,
        boxFit: BoxFit.fitHeight,
        imageType: ImageType.Backdrop,
        showParent: true,
        backup: item.type == ItemType.TvChannel ? true : false);
  }
}
