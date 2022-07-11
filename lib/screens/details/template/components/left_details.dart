import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import '../../bloc/details_bloc.dart';

class LeftDetails extends StatelessWidget {
  const LeftDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Poster(
        key: ValueKey(context.read<DetailsBloc>().state.item),
        item: context.read<DetailsBloc>().state.item,
        heroTag: context.read<DetailsBloc>().state.heroTag,
        imageType: ImageType.Primary,
        clickable: false,
        dropShadow: true,
        showParent: false,
        boxFit: BoxFit.contain,
      ),
    );
  }
}
