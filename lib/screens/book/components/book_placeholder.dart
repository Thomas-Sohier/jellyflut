import 'package:flutter/material.dart';
import 'package:jellyflut/components/logo.dart';

import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/screens/book/components/loading_text.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:uuid/uuid.dart';

class BookPlaceholder extends StatelessWidget {
  final Item item;
  const BookPlaceholder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
            child: SizedBox(
          height: double.maxFinite,
          child: AspectRatio(
            aspectRatio: item.getPrimaryAspectRatio(),
            child: Poster(
                key: ValueKey(item),
                imageType: ImageType.Primary,
                heroTag: '${item.id}-${Uuid().v1()}',
                clickable: false,
                width: double.infinity,
                height: double.infinity,
                boxFit: BoxFit.contain,
                item: item),
          ),
        )),
        Container(color: Colors.black38),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingText(),
            const SizedBox(height: 24),
            Logo(item: item),
          ],
        )
      ],
    );
  }
}
