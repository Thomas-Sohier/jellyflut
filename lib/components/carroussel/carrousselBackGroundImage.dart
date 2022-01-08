import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:provider/provider.dart';

class CarrousselBackGroundImage extends StatefulWidget {
  CarrousselBackGroundImage({Key? key}) : super(key: key);

  @override
  _CarrousselBackGroundImageState createState() =>
      _CarrousselBackGroundImageState();
}

class _CarrousselBackGroundImageState extends State<CarrousselBackGroundImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrousselProvider>(
        builder: (context, carrousselProvider, child) {
      if (carrousselProvider.item != null) {
        return AsyncImage(
          item: carrousselProvider.item!,
          tag: ImageType.PRIMARY,
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
