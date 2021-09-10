import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/book/components/loading_text.dart';

class BookPlaceholder extends StatelessWidget {
  final Item item;
  const BookPlaceholder({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
            child: Poster(
                tag: ImageType.PRIMARY,
                heroTag: null,
                clickable: false,
                boxFit: BoxFit.contain,
                item: item)),
        Container(color: Colors.black38),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingText(),
            const SizedBox(height: 24),
            Logo(item: item, size: MediaQuery.of(context).size),
          ],
        )
      ],
    );
  }
}
