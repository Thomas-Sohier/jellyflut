import 'package:auto_route/auto_route.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut_models/jellyflut_models.dart';

import '../async_item_image/async_item_image.dart';

class Poster extends StatefulWidget {
  final ImageType imageType;
  final BoxFit boxFit;
  final Item item;
  final double? height;
  final double? width;
  final bool backup;
  final bool showParent;
  final bool dropShadow;
  final bool clickable;
  final bool showOverlay;
  final String? heroTag;
  final Widget? notFoundPlaceholder;

  const Poster(
      {super.key,
      this.showParent = false,
      this.dropShadow = false,
      this.backup = true,
      this.showOverlay = false,
      this.height,
      this.notFoundPlaceholder,
      this.width,
      this.heroTag,
      this.clickable = true,
      required this.imageType,
      required this.boxFit,
      required this.item});
  @override
  State<Poster> createState() => _PosterState();
}

class _PosterState extends State<Poster> with AbsordAction {
  late final FocusNode node;
  late final ZoomableImageController _zoomableImageController;

  @override
  void initState() {
    node = FocusNode();
    node.addListener(() {
      if (node.hasFocus) {
        zoom();
      } else {
        zoomOut();
      }
    });
    _zoomableImageController = ZoomableImageController();
    super.initState();
  }

  void zoom([PointerEvent? event]) {
    if (mounted) {
      _zoomableImageController.zoom();
    }
  }

  void zoomOut([PointerEvent? event]) {
    if (mounted) {
      _zoomableImageController.zoomOut();
    }
  }

  Future<void> redirection() {
    return context.router.root.push(r.DetailsPage(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clickable) {
      return OutlinedButton(
        onPressed: () => action(redirection),
        autofocus: false,
        focusNode: node,
        style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                backgroundColor: Colors.transparent)
            .copyWith(shadowColor: buttonShadow())
            .copyWith(side: buttonBorderSide())
            .copyWith(elevation: buttonElevation()),
        child: MouseRegion(onEnter: zoom, onExit: zoomOut, child: poster()),
      );
    }
    return poster();
  }

  Widget poster() {
    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: dropShadowBuilder(AsyncImage(
            item: widget.item,
            imageType: widget.imageType,
            boxFit: widget.boxFit,
            width: widget.width,
            height: widget.height,
            backup: widget.backup,
            notFoundPlaceholder: widget.notFoundPlaceholder,
            zoomableImageController: _zoomableImageController,
            showOverlay: widget.showOverlay,
            showParent: widget.showParent)),
      );
    }
    return dropShadowBuilder(AsyncImage(
        item: widget.item, imageType: widget.imageType, boxFit: widget.boxFit, showParent: widget.showParent));
  }

  Widget dropShadowBuilder(Widget child) {
    if (widget.dropShadow) {
      return DropShadow(blurRadius: 6, spread: 1, offset: const Offset(0, 0), child: child);
    }
    return child;
  }

  MaterialStateProperty<Color> buttonShadow() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return Theme.of(context).colorScheme.secondary;
        }
        return Colors.transparent; // defer to the default
      },
    );
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return 8;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.onBackground,
          );
        }
        return BorderSide(width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }

  MaterialStateProperty<EdgeInsetsGeometry> buttonPadding() {
    return MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return EdgeInsets.all(3);
      }
      return EdgeInsets.zero;
    });
  }
}
