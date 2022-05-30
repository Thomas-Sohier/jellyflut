import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/template/components/async_right_details.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';

class LargeDetails extends StatelessWidget {
  final Item item;
  final String? heroTag;

  const LargeDetails({required this.item, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(item: item, imageType: ImageType.BACKDROP),
      DetailsBackgroundBuilder(),
      LayoutBuilder(builder: ((_, constraints) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              leftDetailsPart(constraints),
              rightDetailsPart(constraints)
            ]);
      }))
    ]);
  }

  Widget leftDetailsPart(BoxConstraints constraints) {
    if (constraints.maxWidth <= 960) return const SizedBox();
    return Expanded(
        flex: 4,
        child: LeftDetails(
            item: item, heroTag: heroTag, constraints: constraints));
  }

  Widget rightDetailsPart(BoxConstraints constraints) {
    return Expanded(
        flex: 6,
        child: AsyncRightDetails(item: item, constraints: constraints));
  }
}
