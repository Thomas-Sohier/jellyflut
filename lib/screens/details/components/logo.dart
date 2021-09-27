import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class Logo extends StatelessWidget {
  final Item item;

  const Logo({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        constraints: BoxConstraints(maxWidth: 400),
        height: 100,
        child: AsyncImage(
          item: item,
          showParent: true,
          boxFit: BoxFit.contain,
          errorWidget: SizedBox(),
          placeholder: SizedBox(),
          tag: ImageType.LOGO,
        ));
  }
}
