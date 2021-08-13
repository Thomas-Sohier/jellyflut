import 'package:flutter/material.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';

import '../asyncImage.dart';

class Poster extends StatelessWidget {
  final String tag;
  final BoxFit boxFit;
  final Item item;
  final bool showParent;
  final bool clickable;
  final String heroTag;
  final double? aspectRatio;

  const Poster(
      {this.showParent = false,
      this.aspectRatio,
      required this.tag,
      required this.heroTag,
      required this.clickable,
      required this.boxFit,
      required this.item});

  void onTap() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Details(item: item, heroTag: heroTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusNode();
    ;
    if (clickable) {
      return OutlinedButton(
        onPressed: () => onTap(),
        autofocus: false,
        focusNode: node,
        style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                backgroundColor: Colors.transparent)
            .copyWith(side: buttonBorderSide())
            .copyWith(padding: buttonPadding())
            .copyWith(elevation: buttonElevation()),
        child: poster(),
      );
    }
    return poster();
  }

  Widget poster() {
    return Hero(
      tag: heroTag,
      child: AspectRatio(
          aspectRatio:
              aspectRatio != null ? aspectRatio! : item.getPrimaryAspectRatio(),
          child: AsyncImage(
            showParent ? item.getParentId() : item.getIdBasedOnImage(),
            item.imageTags?.primary ?? '',
            item.imageBlurHashes!,
            tag: tag,
            boxFit: boxFit,
          )),
    );
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return 2;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }

  MaterialStateProperty<EdgeInsetsGeometry> buttonPadding() {
    return MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return EdgeInsets.all(8);
      }
      return EdgeInsets.zero;
    });
  }
}
