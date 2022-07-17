import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/poster/poster.dart' as root_poster;
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Poster extends StatelessWidget {
  final String? heroTag;

  const Poster({super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: root_poster.Poster(
          item: state.item,
          key: ValueKey(state.item),
          boxFit: BoxFit.cover,
          clickable: false,
          showParent: true,
          imageType: ImageType.Primary,
          heroTag: heroTag,
        ));
  }
}
