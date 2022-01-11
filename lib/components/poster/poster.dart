import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';

import '../async_image.dart';

class Poster extends StatefulWidget {
  final ImageType tag;
  final BoxFit boxFit;
  final Item item;
  final double? height;
  final double? width;
  final bool backup;
  final bool showParent;
  final bool dropShadow;
  final bool clickable;
  final String? heroTag;

  const Poster(
      {Key? key,
      this.showParent = false,
      this.dropShadow = false,
      this.backup = true,
      this.height,
      this.width,
      required this.tag,
      required this.heroTag,
      required this.clickable,
      required this.boxFit,
      required this.item})
      : super(key: key);
  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  late final FocusNode node;

  @override
  void initState() {
    node = FocusNode();
    super.initState();
  }

  void onTap() {
    customRouter.push(DetailsRoute(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
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
    if (widget.heroTag != null) {
      return Hero(
        tag: '${widget.heroTag!}-${widget.item.name}-poster',
        child: dropShadowBuilder(AsyncImage(
            item: widget.item,
            tag: widget.tag,
            boxFit: widget.boxFit,
            width: widget.width,
            height: widget.height,
            backup: widget.backup,
            showParent: widget.showParent)),
      );
    }
    return dropShadowBuilder(AsyncImage(
        item: widget.item,
        tag: widget.tag,
        boxFit: widget.boxFit,
        showParent: widget.showParent));
  }

  Widget dropShadowBuilder(Widget child) {
    if (widget.dropShadow) {
      return DropShadow(
          blurRadius: 8, offset: const Offset(0, 0), child: child);
    }
    return child;
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
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
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
        return EdgeInsets.all(4);
      }
      return EdgeInsets.zero;
    });
  }
}
