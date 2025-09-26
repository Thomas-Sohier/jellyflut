import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Poster extends StatelessWidget {
  const Poster({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: ItemPoster(
        state.item,
        key: ValueKey(state.item),
        boxFit: BoxFit.cover,
        clickable: false,
        showParent: true,
        showOverlay: false,
        showLogo: false,
        showName: false,
        tag: ImageType.Primary,
        heroTag: state.heroTag,
      ),
    );
  }
}
