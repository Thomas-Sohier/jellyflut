import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/imageType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';

import '../asyncImage.dart';

class Poster extends StatefulWidget {
  final ImageType tag;
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
  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  late final FocusNode node;
  late double aspectRatio;
  late String itemId;

  @override
  void initState() {
    node = FocusNode();
    aspectRatio = widget.aspectRatio != null
        ? widget.aspectRatio!
        : widget.item.getPrimaryAspectRatio();
    itemId = widget.showParent
        ? widget.item.getParentId()
        : widget.item.getIdBasedOnImage();
    super.initState();
  }

  void onTap() {
    customRouter.push(DetailsRoute(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
    aspectRatio = widget.aspectRatio != null
        ? widget.aspectRatio!
        : widget.item.getPrimaryAspectRatio();
    itemId = widget.showParent
        ? widget.item.getParentId()
        : widget.item.getIdBasedOnImage();
    if (widget.clickable) {
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
      tag: widget.heroTag,
      child: AsyncImage(
        itemId,
        widget.item.imageTags!
            .firstWhere((element) => element.imageType == ImageType.PRIMARY)
            .value,
        widget.item.imageBlurHashes!,
        tag: widget.tag,
        boxFit: widget.boxFit,
      ),
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
