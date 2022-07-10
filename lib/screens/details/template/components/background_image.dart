import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class BackgroundImage extends StatelessWidget {
  final ImageType imageType;

  const BackgroundImage({super.key, this.imageType = ImageType.Primary});

  @override
  Widget build(BuildContext context) {
    return AsyncImage(
      item: context.read<DetailsBloc>().state.item,
      width: double.infinity,
      height: double.infinity,
      tag: imageType,
      boxFit: BoxFit.cover,
    );
  }
}
