import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class Logo extends StatelessWidget {
  final Item item;
  final Size size;

  const Logo({Key? key, required this.item, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        constraints: BoxConstraints(maxWidth: 400),
        height: 100,
        child: AsyncImage(
          item.correctImageId(searchType: 'logo'),
          item.correctImageTags(searchType: 'logo'),
          item.imageBlurHashes!,
          boxFit: BoxFit.contain,
          tag: 'Logo',
        ));
  }
}
