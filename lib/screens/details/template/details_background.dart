import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/screens/settings/bloc/settings_bloc.dart';
import 'package:jellyflut/theme/theme_extend_own.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import '../bloc/details_bloc.dart';

class DetailsBackground extends StatelessWidget {
  static const duration = Duration(milliseconds: 500);
  const DetailsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsBloc>().state;
    if (settings.detailsPageContrasted) return const SizedBox();
    return Stack(
      children: [
        AsyncImageProvider(
          item: context.read<DetailsBloc>().state.item,
          imageType: ImageType.Backdrop,
          builder: (context, imageProvider, imageInfo) {
            return Image(image: imageProvider, fit: BoxFit.cover);
          },
        ),
        ClipRect(
          clipBehavior: Clip.hardEdge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
            child: AnimatedContainer(
              duration: duration,
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.6),
                gradient: LinearGradient(
                  colors: [
                    ownDetailsTheme(context).primary,
                    ownDetailsTheme(context).secondary,
                    ownDetailsTheme(context).tertiary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
