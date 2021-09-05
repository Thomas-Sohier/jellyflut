import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
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
          item.correctImageId(searchType: ImageType.LOGO),
          item.correctImageTags(searchType: ImageType.LOGO),
          item.imageBlurHashes!,
          boxFit: BoxFit.contain,
          errorWidget: SizedBox(),
          placeholder: SizedBox(),
          tag: ImageType.LOGO,
        ));
  }
}
