import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/book/components/loading_text.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:uuid/uuid.dart';

class BookPlaceholder extends StatelessWidget {
  final Item item;
  const BookPlaceholder({Key? key, required this.item}) : super(key: key);

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
                tag: ImageType.PRIMARY,
                heroTag: '${item.id}-${Uuid().v1()}',
                clickable: false,
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
