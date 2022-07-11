import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:provider/provider.dart';

class CarrousselBackGroundImage extends StatefulWidget {
  CarrousselBackGroundImage({super.key});

  @override
  State<CarrousselBackGroundImage> createState() => _CarrousselBackGroundImageState();
}

class _CarrousselBackGroundImageState extends State<CarrousselBackGroundImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrousselProvider>(builder: (context, carrousselProvider, child) {
      if (carrousselProvider.item != null) {
        return AsyncImage(
          item: carrousselProvider.item!,
          imageType: ImageType.Primary,
          boxFit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
